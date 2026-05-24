// AlbumsApi.mo

import Text "mo:core/Text";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Iter "mo:core/Iter";
import Blob "mo:core/Blob";
import Array "mo:core/Array";
import List "mo:core/List";
import Error "mo:core/Error";
import Base64 "mo:core/Base64";
import { JSON; Candid } "mo:serde-core";
import { type HttpRequestArgs; type HttpRequestResult; type HttpHeader } "mo:ic/Types";
import { type AlbumObject; JSON = AlbumObject } "../Models/AlbumObject";
import { type GetAnAlbum401Response; JSON = GetAnAlbum401Response } "../Models/GetAnAlbum401Response";
import { type GetMultipleAlbums200Response; JSON = GetMultipleAlbums200Response } "../Models/GetMultipleAlbums200Response";
import { type GetNewReleases200Response; JSON = GetNewReleases200Response } "../Models/GetNewReleases200Response";
import { type PagingArtistDiscographyAlbumObject; JSON = PagingArtistDiscographyAlbumObject } "../Models/PagingArtistDiscographyAlbumObject";
import { type PagingSavedAlbumObject; JSON = PagingSavedAlbumObject } "../Models/PagingSavedAlbumObject";
import { type PagingSimplifiedTrackObject; JSON = PagingSimplifiedTrackObject } "../Models/PagingSimplifiedTrackObject";
import { type SaveAlbumsUserRequest; JSON = SaveAlbumsUserRequest } "../Models/SaveAlbumsUserRequest";
import { type Config } "../Config";

module {
    let http_request = (actor "aaaaa-aa" : actor { http_request : (HttpRequestArgs) -> async HttpRequestResult }).http_request;


    /// Check User's Saved Albums 
    ///
    /// Check if one or more albums is already saved in the current Spotify user's 'Your Music' library. 
    public func checkUsersSavedAlbums(config : Config, ids : Text) : async* [Bool] {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/me/albums/contains"
            # "?" # "ids=" # ids;

        // Add API key as query parameter if using apiKey auth
        let url = switch (config.auth) {
            case _ baseUrl__;
        };

        let baseHeaders = [
            { name = "Content-Type"; value = "application/json; charset=utf-8" }
        ];

        // Build authentication headers based on auth type
        let authHeaders = switch (config.auth) {
            case (?#bearer(token)) {
                [{ name = "Authorization"; value = "Bearer " # token }]
            };
            case (?#apiKey(key)) {
                // API key goes in query parameter, not header
                []
            };
            case (?#basicAuth({user; password})) {
                let encoded = Base64.encode(Text.encodeUtf8(user # ":" # password));
                [{ name = "Authorization"; value = "Basic " # encoded }]
            };
            case null [];
        };

        let headers = Array.flatten<HttpHeader>([
            baseHeaders,
            authHeaders
        ]);

        let request : HttpRequestArgs = { config with
            url;
            method = #get;
            headers;
            body = null;
        };

        // Call the management canister's http_request method with cycles
        let response : HttpRequestResult = await (with cycles) http_request(request);

        // Check HTTP status code before parsing
        if (response.status >= 200 and response.status < 300) {
            // Success response (2xx): parse as expected return type
            (switch (Text.decodeUtf8(response.body)) {
                case (?text) text;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to decode response body as UTF-8");
            }) |>
            (switch (JSON.toCandid(_)) {
                case (#ok(c__)) c__;
                case (#err(msg)) throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to parse JSON: " # msg);
            }) |>
            (switch (_) {
                case (#Array(xs__)) {
                    let buf__ = List.empty<Bool>();
                    for (c__ in xs__.values()) {
                        let #Bool(v__) = c__ else throw Error.reject("HTTP " # Int.toText(response.status) # ": Expected array of Bool");
                        List.add(buf__, v__);
                    };
                    List.toArray(buf__);
                };
                case _ throw Error.reject("HTTP " # Int.toText(response.status) # ": Expected JSON array");
            })
        } else {
            // Error response (4xx, 5xx): parse error models and throw
            let responseText = switch (Text.decodeUtf8(response.body)) {
                case (?text) text;
                case null "";  // Empty body for some errors (e.g., 404)
            };

            // Try parsing 401 response as GetAnAlbum401Response
            if (response.status == 401) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 401: Bad or expired token. This can happen if the user revoked a token or the access token has expired. You should re-authenticate the user. " # errorDetail);
            };
            // Try parsing 403 response as GetAnAlbum401Response
            if (response.status == 403) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 403: Bad OAuth request (wrong consumer key, bad nonce, expired timestamp...). Unfortunately, re-authenticating the user won&#39;t help here. " # errorDetail);
            };
            // Try parsing 429 response as GetAnAlbum401Response
            if (response.status == 429) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 429: The app has exceeded its rate limits. " # errorDetail);
            };

            // Fallback for status codes not defined in OpenAPI spec
            throw Error.reject("HTTP " # Int.toText(response.status) # ": Unexpected error" #
                (if (responseText != "") { " - " # responseText } else { "" }));
        }
    };

    /// Get Album 
    ///
    /// Get Spotify catalog information for a single album. 
    public func getAnAlbum(config : Config, id : Text, market : Text) : async* AlbumObject {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/albums/{id}"
            |> Text.replace(_, #text "{id}", id)
            # "?" # "market=" # market;

        // Add API key as query parameter if using apiKey auth
        let url = switch (config.auth) {
            case _ baseUrl__;
        };

        let baseHeaders = [
            { name = "Content-Type"; value = "application/json; charset=utf-8" }
        ];

        // Build authentication headers based on auth type
        let authHeaders = switch (config.auth) {
            case (?#bearer(token)) {
                [{ name = "Authorization"; value = "Bearer " # token }]
            };
            case (?#apiKey(key)) {
                // API key goes in query parameter, not header
                []
            };
            case (?#basicAuth({user; password})) {
                let encoded = Base64.encode(Text.encodeUtf8(user # ":" # password));
                [{ name = "Authorization"; value = "Basic " # encoded }]
            };
            case null [];
        };

        let headers = Array.flatten<HttpHeader>([
            baseHeaders,
            authHeaders
        ]);

        let request : HttpRequestArgs = { config with
            url;
            method = #get;
            headers;
            body = null;
        };

        // Call the management canister's http_request method with cycles
        let response : HttpRequestResult = await (with cycles) http_request(request);

        // Check HTTP status code before parsing
        if (response.status >= 200 and response.status < 300) {
            // Success response (2xx): parse as expected return type
            (switch (Text.decodeUtf8(response.body)) {
                case (?text) text;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to decode response body as UTF-8");
            }) |>
            (switch (JSON.toCandid(_)) {
                case (#ok(c__)) c__;
                case (#err(msg)) throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to parse JSON: " # msg);
            }) |>
            (switch (AlbumObject.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to AlbumObject");
            })
        } else {
            // Error response (4xx, 5xx): parse error models and throw
            let responseText = switch (Text.decodeUtf8(response.body)) {
                case (?text) text;
                case null "";  // Empty body for some errors (e.g., 404)
            };

            // Try parsing 401 response as GetAnAlbum401Response
            if (response.status == 401) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 401: Bad or expired token. This can happen if the user revoked a token or the access token has expired. You should re-authenticate the user. " # errorDetail);
            };
            // Try parsing 403 response as GetAnAlbum401Response
            if (response.status == 403) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 403: Bad OAuth request (wrong consumer key, bad nonce, expired timestamp...). Unfortunately, re-authenticating the user won&#39;t help here. " # errorDetail);
            };
            // Try parsing 429 response as GetAnAlbum401Response
            if (response.status == 429) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 429: The app has exceeded its rate limits. " # errorDetail);
            };

            // Fallback for status codes not defined in OpenAPI spec
            throw Error.reject("HTTP " # Int.toText(response.status) # ": Unexpected error" #
                (if (responseText != "") { " - " # responseText } else { "" }));
        }
    };

    /// Get Album Tracks 
    ///
    /// Get Spotify catalog information about an album’s tracks. Optional parameters can be used to limit the number of tracks returned. 
    public func getAnAlbumsTracks(config : Config, id : Text, market : Text, limit : Nat, offset : Int) : async* PagingSimplifiedTrackObject {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/albums/{id}/tracks"
            |> Text.replace(_, #text "{id}", id)
            # "?" # "market=" # market # "&" # "limit=" # Int.toText(limit) # "&" # "offset=" # Int.toText(offset);

        // Add API key as query parameter if using apiKey auth
        let url = switch (config.auth) {
            case _ baseUrl__;
        };

        let baseHeaders = [
            { name = "Content-Type"; value = "application/json; charset=utf-8" }
        ];

        // Build authentication headers based on auth type
        let authHeaders = switch (config.auth) {
            case (?#bearer(token)) {
                [{ name = "Authorization"; value = "Bearer " # token }]
            };
            case (?#apiKey(key)) {
                // API key goes in query parameter, not header
                []
            };
            case (?#basicAuth({user; password})) {
                let encoded = Base64.encode(Text.encodeUtf8(user # ":" # password));
                [{ name = "Authorization"; value = "Basic " # encoded }]
            };
            case null [];
        };

        let headers = Array.flatten<HttpHeader>([
            baseHeaders,
            authHeaders
        ]);

        let request : HttpRequestArgs = { config with
            url;
            method = #get;
            headers;
            body = null;
        };

        // Call the management canister's http_request method with cycles
        let response : HttpRequestResult = await (with cycles) http_request(request);

        // Check HTTP status code before parsing
        if (response.status >= 200 and response.status < 300) {
            // Success response (2xx): parse as expected return type
            (switch (Text.decodeUtf8(response.body)) {
                case (?text) text;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to decode response body as UTF-8");
            }) |>
            (switch (JSON.toCandid(_)) {
                case (#ok(c__)) c__;
                case (#err(msg)) throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to parse JSON: " # msg);
            }) |>
            (switch (PagingSimplifiedTrackObject.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to PagingSimplifiedTrackObject");
            })
        } else {
            // Error response (4xx, 5xx): parse error models and throw
            let responseText = switch (Text.decodeUtf8(response.body)) {
                case (?text) text;
                case null "";  // Empty body for some errors (e.g., 404)
            };

            // Try parsing 401 response as GetAnAlbum401Response
            if (response.status == 401) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 401: Bad or expired token. This can happen if the user revoked a token or the access token has expired. You should re-authenticate the user. " # errorDetail);
            };
            // Try parsing 403 response as GetAnAlbum401Response
            if (response.status == 403) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 403: Bad OAuth request (wrong consumer key, bad nonce, expired timestamp...). Unfortunately, re-authenticating the user won&#39;t help here. " # errorDetail);
            };
            // Try parsing 429 response as GetAnAlbum401Response
            if (response.status == 429) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 429: The app has exceeded its rate limits. " # errorDetail);
            };

            // Fallback for status codes not defined in OpenAPI spec
            throw Error.reject("HTTP " # Int.toText(response.status) # ": Unexpected error" #
                (if (responseText != "") { " - " # responseText } else { "" }));
        }
    };

    /// Get Artist's Albums 
    ///
    /// Get Spotify catalog information about an artist's albums. 
    public func getAnArtistsAlbums(config : Config, id : Text, includeGroups : Text, market : Text, limit : Nat, offset : Int) : async* PagingArtistDiscographyAlbumObject {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/artists/{id}/albums"
            |> Text.replace(_, #text "{id}", id)
            # "?" # "include_groups=" # includeGroups # "&" # "market=" # market # "&" # "limit=" # Int.toText(limit) # "&" # "offset=" # Int.toText(offset);

        // Add API key as query parameter if using apiKey auth
        let url = switch (config.auth) {
            case _ baseUrl__;
        };

        let baseHeaders = [
            { name = "Content-Type"; value = "application/json; charset=utf-8" }
        ];

        // Build authentication headers based on auth type
        let authHeaders = switch (config.auth) {
            case (?#bearer(token)) {
                [{ name = "Authorization"; value = "Bearer " # token }]
            };
            case (?#apiKey(key)) {
                // API key goes in query parameter, not header
                []
            };
            case (?#basicAuth({user; password})) {
                let encoded = Base64.encode(Text.encodeUtf8(user # ":" # password));
                [{ name = "Authorization"; value = "Basic " # encoded }]
            };
            case null [];
        };

        let headers = Array.flatten<HttpHeader>([
            baseHeaders,
            authHeaders
        ]);

        let request : HttpRequestArgs = { config with
            url;
            method = #get;
            headers;
            body = null;
        };

        // Call the management canister's http_request method with cycles
        let response : HttpRequestResult = await (with cycles) http_request(request);

        // Check HTTP status code before parsing
        if (response.status >= 200 and response.status < 300) {
            // Success response (2xx): parse as expected return type
            (switch (Text.decodeUtf8(response.body)) {
                case (?text) text;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to decode response body as UTF-8");
            }) |>
            (switch (JSON.toCandid(_)) {
                case (#ok(c__)) c__;
                case (#err(msg)) throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to parse JSON: " # msg);
            }) |>
            (switch (PagingArtistDiscographyAlbumObject.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to PagingArtistDiscographyAlbumObject");
            })
        } else {
            // Error response (4xx, 5xx): parse error models and throw
            let responseText = switch (Text.decodeUtf8(response.body)) {
                case (?text) text;
                case null "";  // Empty body for some errors (e.g., 404)
            };

            // Try parsing 401 response as GetAnAlbum401Response
            if (response.status == 401) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 401: Bad or expired token. This can happen if the user revoked a token or the access token has expired. You should re-authenticate the user. " # errorDetail);
            };
            // Try parsing 403 response as GetAnAlbum401Response
            if (response.status == 403) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 403: Bad OAuth request (wrong consumer key, bad nonce, expired timestamp...). Unfortunately, re-authenticating the user won&#39;t help here. " # errorDetail);
            };
            // Try parsing 429 response as GetAnAlbum401Response
            if (response.status == 429) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 429: The app has exceeded its rate limits. " # errorDetail);
            };

            // Fallback for status codes not defined in OpenAPI spec
            throw Error.reject("HTTP " # Int.toText(response.status) # ": Unexpected error" #
                (if (responseText != "") { " - " # responseText } else { "" }));
        }
    };

    /// Get Several Albums 
    ///
    /// Get Spotify catalog information for multiple albums identified by their Spotify IDs. 
    public func getMultipleAlbums(config : Config, ids : Text, market : Text) : async* GetMultipleAlbums200Response {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/albums"
            # "?" # "ids=" # ids # "&" # "market=" # market;

        // Add API key as query parameter if using apiKey auth
        let url = switch (config.auth) {
            case _ baseUrl__;
        };

        let baseHeaders = [
            { name = "Content-Type"; value = "application/json; charset=utf-8" }
        ];

        // Build authentication headers based on auth type
        let authHeaders = switch (config.auth) {
            case (?#bearer(token)) {
                [{ name = "Authorization"; value = "Bearer " # token }]
            };
            case (?#apiKey(key)) {
                // API key goes in query parameter, not header
                []
            };
            case (?#basicAuth({user; password})) {
                let encoded = Base64.encode(Text.encodeUtf8(user # ":" # password));
                [{ name = "Authorization"; value = "Basic " # encoded }]
            };
            case null [];
        };

        let headers = Array.flatten<HttpHeader>([
            baseHeaders,
            authHeaders
        ]);

        let request : HttpRequestArgs = { config with
            url;
            method = #get;
            headers;
            body = null;
        };

        // Call the management canister's http_request method with cycles
        let response : HttpRequestResult = await (with cycles) http_request(request);

        // Check HTTP status code before parsing
        if (response.status >= 200 and response.status < 300) {
            // Success response (2xx): parse as expected return type
            (switch (Text.decodeUtf8(response.body)) {
                case (?text) text;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to decode response body as UTF-8");
            }) |>
            (switch (JSON.toCandid(_)) {
                case (#ok(c__)) c__;
                case (#err(msg)) throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to parse JSON: " # msg);
            }) |>
            (switch (GetMultipleAlbums200Response.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to GetMultipleAlbums200Response");
            })
        } else {
            // Error response (4xx, 5xx): parse error models and throw
            let responseText = switch (Text.decodeUtf8(response.body)) {
                case (?text) text;
                case null "";  // Empty body for some errors (e.g., 404)
            };

            // Try parsing 401 response as GetAnAlbum401Response
            if (response.status == 401) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 401: Bad or expired token. This can happen if the user revoked a token or the access token has expired. You should re-authenticate the user. " # errorDetail);
            };
            // Try parsing 403 response as GetAnAlbum401Response
            if (response.status == 403) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 403: Bad OAuth request (wrong consumer key, bad nonce, expired timestamp...). Unfortunately, re-authenticating the user won&#39;t help here. " # errorDetail);
            };
            // Try parsing 429 response as GetAnAlbum401Response
            if (response.status == 429) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 429: The app has exceeded its rate limits. " # errorDetail);
            };

            // Fallback for status codes not defined in OpenAPI spec
            throw Error.reject("HTTP " # Int.toText(response.status) # ": Unexpected error" #
                (if (responseText != "") { " - " # responseText } else { "" }));
        }
    };

    /// Get New Releases 
    ///
    /// Get a list of new album releases featured in Spotify (shown, for example, on a Spotify player’s “Browse” tab). 
    public func getNewReleases(config : Config, limit : Nat, offset : Int) : async* GetNewReleases200Response {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/browse/new-releases"
            # "?" # "limit=" # Int.toText(limit) # "&" # "offset=" # Int.toText(offset);

        // Add API key as query parameter if using apiKey auth
        let url = switch (config.auth) {
            case _ baseUrl__;
        };

        let baseHeaders = [
            { name = "Content-Type"; value = "application/json; charset=utf-8" }
        ];

        // Build authentication headers based on auth type
        let authHeaders = switch (config.auth) {
            case (?#bearer(token)) {
                [{ name = "Authorization"; value = "Bearer " # token }]
            };
            case (?#apiKey(key)) {
                // API key goes in query parameter, not header
                []
            };
            case (?#basicAuth({user; password})) {
                let encoded = Base64.encode(Text.encodeUtf8(user # ":" # password));
                [{ name = "Authorization"; value = "Basic " # encoded }]
            };
            case null [];
        };

        let headers = Array.flatten<HttpHeader>([
            baseHeaders,
            authHeaders
        ]);

        let request : HttpRequestArgs = { config with
            url;
            method = #get;
            headers;
            body = null;
        };

        // Call the management canister's http_request method with cycles
        let response : HttpRequestResult = await (with cycles) http_request(request);

        // Check HTTP status code before parsing
        if (response.status >= 200 and response.status < 300) {
            // Success response (2xx): parse as expected return type
            (switch (Text.decodeUtf8(response.body)) {
                case (?text) text;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to decode response body as UTF-8");
            }) |>
            (switch (JSON.toCandid(_)) {
                case (#ok(c__)) c__;
                case (#err(msg)) throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to parse JSON: " # msg);
            }) |>
            (switch (GetNewReleases200Response.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to GetNewReleases200Response");
            })
        } else {
            // Error response (4xx, 5xx): parse error models and throw
            let responseText = switch (Text.decodeUtf8(response.body)) {
                case (?text) text;
                case null "";  // Empty body for some errors (e.g., 404)
            };

            // Try parsing 401 response as GetAnAlbum401Response
            if (response.status == 401) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 401: Bad or expired token. This can happen if the user revoked a token or the access token has expired. You should re-authenticate the user. " # errorDetail);
            };
            // Try parsing 403 response as GetAnAlbum401Response
            if (response.status == 403) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 403: Bad OAuth request (wrong consumer key, bad nonce, expired timestamp...). Unfortunately, re-authenticating the user won&#39;t help here. " # errorDetail);
            };
            // Try parsing 429 response as GetAnAlbum401Response
            if (response.status == 429) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 429: The app has exceeded its rate limits. " # errorDetail);
            };

            // Fallback for status codes not defined in OpenAPI spec
            throw Error.reject("HTTP " # Int.toText(response.status) # ": Unexpected error" #
                (if (responseText != "") { " - " # responseText } else { "" }));
        }
    };

    /// Get User's Saved Albums 
    ///
    /// Get a list of the albums saved in the current Spotify user's 'Your Music' library. 
    public func getUsersSavedAlbums(config : Config, limit : Nat, offset : Int, market : Text) : async* PagingSavedAlbumObject {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/me/albums"
            # "?" # "limit=" # Int.toText(limit) # "&" # "offset=" # Int.toText(offset) # "&" # "market=" # market;

        // Add API key as query parameter if using apiKey auth
        let url = switch (config.auth) {
            case _ baseUrl__;
        };

        let baseHeaders = [
            { name = "Content-Type"; value = "application/json; charset=utf-8" }
        ];

        // Build authentication headers based on auth type
        let authHeaders = switch (config.auth) {
            case (?#bearer(token)) {
                [{ name = "Authorization"; value = "Bearer " # token }]
            };
            case (?#apiKey(key)) {
                // API key goes in query parameter, not header
                []
            };
            case (?#basicAuth({user; password})) {
                let encoded = Base64.encode(Text.encodeUtf8(user # ":" # password));
                [{ name = "Authorization"; value = "Basic " # encoded }]
            };
            case null [];
        };

        let headers = Array.flatten<HttpHeader>([
            baseHeaders,
            authHeaders
        ]);

        let request : HttpRequestArgs = { config with
            url;
            method = #get;
            headers;
            body = null;
        };

        // Call the management canister's http_request method with cycles
        let response : HttpRequestResult = await (with cycles) http_request(request);

        // Check HTTP status code before parsing
        if (response.status >= 200 and response.status < 300) {
            // Success response (2xx): parse as expected return type
            (switch (Text.decodeUtf8(response.body)) {
                case (?text) text;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to decode response body as UTF-8");
            }) |>
            (switch (JSON.toCandid(_)) {
                case (#ok(c__)) c__;
                case (#err(msg)) throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to parse JSON: " # msg);
            }) |>
            (switch (PagingSavedAlbumObject.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to PagingSavedAlbumObject");
            })
        } else {
            // Error response (4xx, 5xx): parse error models and throw
            let responseText = switch (Text.decodeUtf8(response.body)) {
                case (?text) text;
                case null "";  // Empty body for some errors (e.g., 404)
            };

            // Try parsing 401 response as GetAnAlbum401Response
            if (response.status == 401) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 401: Bad or expired token. This can happen if the user revoked a token or the access token has expired. You should re-authenticate the user. " # errorDetail);
            };
            // Try parsing 403 response as GetAnAlbum401Response
            if (response.status == 403) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 403: Bad OAuth request (wrong consumer key, bad nonce, expired timestamp...). Unfortunately, re-authenticating the user won&#39;t help here. " # errorDetail);
            };
            // Try parsing 429 response as GetAnAlbum401Response
            if (response.status == 429) {
                let errorDetail = if (responseText != "") {
                    switch (JSON.toCandid(responseText)) {
                        case (#ok(c__)) {
                            switch (GetAnAlbum401Response.fromCandidValue(c__)) {
                                case (?err) " - " # debug_show(err);
                                case null " - " # responseText;
                            };
                        };
                        case (#err(_)) " - " # responseText;
                    };
                } else { "" };
                throw Error.reject("HTTP 429: The app has exceeded its rate limits. " # errorDetail);
            };

            // Fallback for status codes not defined in OpenAPI spec
            throw Error.reject("HTTP " # Int.toText(response.status) # ": Unexpected error" #
                (if (responseText != "") { " - " # responseText } else { "" }));
        }
    };

    /// Remove Users' Saved Albums 
    ///
    /// Remove one or more albums from the current user's 'Your Music' library. 
    public func removeAlbumsUser(config : Config, ids : Text, saveAlbumsUserRequest : SaveAlbumsUserRequest) : async* () {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/me/albums"
            # "?" # "ids=" # ids;

        // Add API key as query parameter if using apiKey auth
        let url = switch (config.auth) {
            case _ baseUrl__;
        };

        let baseHeaders = [
            { name = "Content-Type"; value = "application/json; charset=utf-8" }
        ];

        // Build authentication headers based on auth type
        let authHeaders = switch (config.auth) {
            case (?#bearer(token)) {
                [{ name = "Authorization"; value = "Bearer " # token }]
            };
            case (?#apiKey(key)) {
                // API key goes in query parameter, not header
                []
            };
            case (?#basicAuth({user; password})) {
                let encoded = Base64.encode(Text.encodeUtf8(user # ":" # password));
                [{ name = "Authorization"; value = "Basic " # encoded }]
            };
            case null [];
        };

        let headers = Array.flatten<HttpHeader>([
            baseHeaders,
            authHeaders
        ]);

        let request : HttpRequestArgs = { config with
            url;
            method = #delete;
            headers;
            body = do ? {
                let candidValue : Candid.Candid = SaveAlbumsUserRequest.toCandidValue(saveAlbumsUserRequest);
                let #ok(jsonText) = JSON.fromCandid(candidValue)
                    else throw Error.reject("Failed to serialize body to JSON");
                Text.encodeUtf8(jsonText)
            };
        };

        // Call the management canister's http_request method with cycles
        ignore await (with cycles) http_request(request);

    };

    /// Save Albums for Current User 
    ///
    /// Save one or more albums to the current user's 'Your Music' library. 
    public func saveAlbumsUser(config : Config, ids : Text, saveAlbumsUserRequest : SaveAlbumsUserRequest) : async* () {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/me/albums"
            # "?" # "ids=" # ids;

        // Add API key as query parameter if using apiKey auth
        let url = switch (config.auth) {
            case _ baseUrl__;
        };

        let baseHeaders = [
            { name = "Content-Type"; value = "application/json; charset=utf-8" }
        ];

        // Build authentication headers based on auth type
        let authHeaders = switch (config.auth) {
            case (?#bearer(token)) {
                [{ name = "Authorization"; value = "Bearer " # token }]
            };
            case (?#apiKey(key)) {
                // API key goes in query parameter, not header
                []
            };
            case (?#basicAuth({user; password})) {
                let encoded = Base64.encode(Text.encodeUtf8(user # ":" # password));
                [{ name = "Authorization"; value = "Basic " # encoded }]
            };
            case null [];
        };

        let headers = Array.flatten<HttpHeader>([
            baseHeaders,
            authHeaders
        ]);

        let request : HttpRequestArgs = { config with
            url;
            method = #put;
            headers;
            body = do ? {
                let candidValue : Candid.Candid = SaveAlbumsUserRequest.toCandidValue(saveAlbumsUserRequest);
                let #ok(jsonText) = JSON.fromCandid(candidValue)
                    else throw Error.reject("Failed to serialize body to JSON");
                Text.encodeUtf8(jsonText)
            };
        };

        // Call the management canister's http_request method with cycles
        ignore await (with cycles) http_request(request);

    };


    let operations__ = {
        checkUsersSavedAlbums;
        getAnAlbum;
        getAnAlbumsTracks;
        getAnArtistsAlbums;
        getMultipleAlbums;
        getNewReleases;
        getUsersSavedAlbums;
        removeAlbumsUser;
        saveAlbumsUser;
    };

    public module class AlbumsApi(config : Config) {
        /// Check User's Saved Albums 
        ///
        /// Check if one or more albums is already saved in the current Spotify user's 'Your Music' library. 
        public func checkUsersSavedAlbums(ids : Text) : async [Bool] {
            await* operations__.checkUsersSavedAlbums(config, ids)
        };

        /// Get Album 
        ///
        /// Get Spotify catalog information for a single album. 
        public func getAnAlbum(id : Text, market : Text) : async AlbumObject {
            await* operations__.getAnAlbum(config, id, market)
        };

        /// Get Album Tracks 
        ///
        /// Get Spotify catalog information about an album’s tracks. Optional parameters can be used to limit the number of tracks returned. 
        public func getAnAlbumsTracks(id : Text, market : Text, limit : Nat, offset : Int) : async PagingSimplifiedTrackObject {
            await* operations__.getAnAlbumsTracks(config, id, market, limit, offset)
        };

        /// Get Artist's Albums 
        ///
        /// Get Spotify catalog information about an artist's albums. 
        public func getAnArtistsAlbums(id : Text, includeGroups : Text, market : Text, limit : Nat, offset : Int) : async PagingArtistDiscographyAlbumObject {
            await* operations__.getAnArtistsAlbums(config, id, includeGroups, market, limit, offset)
        };

        /// Get Several Albums 
        ///
        /// Get Spotify catalog information for multiple albums identified by their Spotify IDs. 
        public func getMultipleAlbums(ids : Text, market : Text) : async GetMultipleAlbums200Response {
            await* operations__.getMultipleAlbums(config, ids, market)
        };

        /// Get New Releases 
        ///
        /// Get a list of new album releases featured in Spotify (shown, for example, on a Spotify player’s “Browse” tab). 
        public func getNewReleases(limit : Nat, offset : Int) : async GetNewReleases200Response {
            await* operations__.getNewReleases(config, limit, offset)
        };

        /// Get User's Saved Albums 
        ///
        /// Get a list of the albums saved in the current Spotify user's 'Your Music' library. 
        public func getUsersSavedAlbums(limit : Nat, offset : Int, market : Text) : async PagingSavedAlbumObject {
            await* operations__.getUsersSavedAlbums(config, limit, offset, market)
        };

        /// Remove Users' Saved Albums 
        ///
        /// Remove one or more albums from the current user's 'Your Music' library. 
        public func removeAlbumsUser(ids : Text, saveAlbumsUserRequest : SaveAlbumsUserRequest) : async () {
            await* operations__.removeAlbumsUser(config, ids, saveAlbumsUserRequest)
        };

        /// Save Albums for Current User 
        ///
        /// Save one or more albums to the current user's 'Your Music' library. 
        public func saveAlbumsUser(ids : Text, saveAlbumsUserRequest : SaveAlbumsUserRequest) : async () {
            await* operations__.saveAlbumsUser(config, ids, saveAlbumsUserRequest)
        };

    }
}
