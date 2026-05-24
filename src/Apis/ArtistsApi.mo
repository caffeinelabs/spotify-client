// ArtistsApi.mo

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
import { type ArtistObject; JSON = ArtistObject } "../Models/ArtistObject";
import { type FollowArtistsUsersRequest; JSON = FollowArtistsUsersRequest } "../Models/FollowArtistsUsersRequest";
import { type GetAnAlbum401Response; JSON = GetAnAlbum401Response } "../Models/GetAnAlbum401Response";
import { type GetAnArtistsTopTracks200Response; JSON = GetAnArtistsTopTracks200Response } "../Models/GetAnArtistsTopTracks200Response";
import { type GetFollowed200Response; JSON = GetFollowed200Response } "../Models/GetFollowed200Response";
import { type GetMultipleArtists200Response; JSON = GetMultipleArtists200Response } "../Models/GetMultipleArtists200Response";
import { type ItemType; JSON = ItemType } "../Models/ItemType";
import { type ItemType1; JSON = ItemType1 } "../Models/ItemType1";
import { type ItemType2; JSON = ItemType2 } "../Models/ItemType2";
import { type PagingArtistDiscographyAlbumObject; JSON = PagingArtistDiscographyAlbumObject } "../Models/PagingArtistDiscographyAlbumObject";
import { type UnfollowArtistsUsersRequest; JSON = UnfollowArtistsUsersRequest } "../Models/UnfollowArtistsUsersRequest";
import { type Config } "../Config";

module {
    let http_request = (actor "aaaaa-aa" : actor { http_request : (HttpRequestArgs) -> async HttpRequestResult }).http_request;


    /// Check If User Follows Artists or Users 
    ///
    /// Check to see if the current user is following one or more artists or other Spotify users. 
    public func checkCurrentUserFollows(config : Config, type_ : ItemType2, ids : Text) : async* [Bool] {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/me/following/contains"
            # "?" # "type=" # ItemType2.toText(type_) # "&" # "ids=" # ids;

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

    /// Follow Artists or Users 
    ///
    /// Add the current user as a follower of one or more artists or other Spotify users. 
    public func followArtistsUsers(config : Config, type_ : ItemType1, ids : Text, followArtistsUsersRequest : FollowArtistsUsersRequest) : async* () {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/me/following"
            # "?" # "type=" # ItemType1.toText(type_) # "&" # "ids=" # ids;

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
                let candidValue : Candid.Candid = FollowArtistsUsersRequest.toCandidValue(followArtistsUsersRequest);
                let #ok(jsonText) = JSON.fromCandid(candidValue)
                    else throw Error.reject("Failed to serialize body to JSON");
                Text.encodeUtf8(jsonText)
            };
        };

        // Call the management canister's http_request method with cycles
        ignore await (with cycles) http_request(request);

    };

    /// Get Artist 
    ///
    /// Get Spotify catalog information for a single artist identified by their unique Spotify ID. 
    public func getAnArtist(config : Config, id : Text) : async* ArtistObject {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/artists/{id}"
            |> Text.replace(_, #text "{id}", id);

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
            (switch (ArtistObject.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to ArtistObject");
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

    /// Get Artist's Related Artists 
    ///
    /// Get Spotify catalog information about artists similar to a given artist. Similarity is based on analysis of the Spotify community's listening history. 
    public func getAnArtistsRelatedArtists(config : Config, id : Text) : async* GetMultipleArtists200Response {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/artists/{id}/related-artists"
            |> Text.replace(_, #text "{id}", id);

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
            (switch (GetMultipleArtists200Response.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to GetMultipleArtists200Response");
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

    /// Get Artist's Top Tracks 
    ///
    /// Get Spotify catalog information about an artist's top tracks by country. 
    public func getAnArtistsTopTracks(config : Config, id : Text, market : Text) : async* GetAnArtistsTopTracks200Response {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/artists/{id}/top-tracks"
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
            (switch (GetAnArtistsTopTracks200Response.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to GetAnArtistsTopTracks200Response");
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

    /// Get Followed Artists 
    ///
    /// Get the current user's followed artists. 
    public func getFollowed(config : Config, type_ : ItemType, after : Text, limit : Nat) : async* GetFollowed200Response {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/me/following"
            # "?" # "type=" # ItemType.toText(type_) # "&" # "after=" # after # "&" # "limit=" # Int.toText(limit);

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
            (switch (GetFollowed200Response.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to GetFollowed200Response");
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

    /// Get Several Artists 
    ///
    /// Get Spotify catalog information for several artists based on their Spotify IDs. 
    public func getMultipleArtists(config : Config, ids : Text) : async* GetMultipleArtists200Response {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/artists"
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
            (switch (GetMultipleArtists200Response.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to GetMultipleArtists200Response");
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

    /// Unfollow Artists or Users 
    ///
    /// Remove the current user as a follower of one or more artists or other Spotify users. 
    public func unfollowArtistsUsers(config : Config, type_ : ItemType2, ids : Text, unfollowArtistsUsersRequest : UnfollowArtistsUsersRequest) : async* () {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/me/following"
            # "?" # "type=" # ItemType2.toText(type_) # "&" # "ids=" # ids;

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
                let candidValue : Candid.Candid = UnfollowArtistsUsersRequest.toCandidValue(unfollowArtistsUsersRequest);
                let #ok(jsonText) = JSON.fromCandid(candidValue)
                    else throw Error.reject("Failed to serialize body to JSON");
                Text.encodeUtf8(jsonText)
            };
        };

        // Call the management canister's http_request method with cycles
        ignore await (with cycles) http_request(request);

    };


    let operations__ = {
        checkCurrentUserFollows;
        followArtistsUsers;
        getAnArtist;
        getAnArtistsAlbums;
        getAnArtistsRelatedArtists;
        getAnArtistsTopTracks;
        getFollowed;
        getMultipleArtists;
        unfollowArtistsUsers;
    };

    public module class ArtistsApi(config : Config) {
        /// Check If User Follows Artists or Users 
        ///
        /// Check to see if the current user is following one or more artists or other Spotify users. 
        public func checkCurrentUserFollows(type_ : ItemType2, ids : Text) : async [Bool] {
            await* operations__.checkCurrentUserFollows(config, type_, ids)
        };

        /// Follow Artists or Users 
        ///
        /// Add the current user as a follower of one or more artists or other Spotify users. 
        public func followArtistsUsers(type_ : ItemType1, ids : Text, followArtistsUsersRequest : FollowArtistsUsersRequest) : async () {
            await* operations__.followArtistsUsers(config, type_, ids, followArtistsUsersRequest)
        };

        /// Get Artist 
        ///
        /// Get Spotify catalog information for a single artist identified by their unique Spotify ID. 
        public func getAnArtist(id : Text) : async ArtistObject {
            await* operations__.getAnArtist(config, id)
        };

        /// Get Artist's Albums 
        ///
        /// Get Spotify catalog information about an artist's albums. 
        public func getAnArtistsAlbums(id : Text, includeGroups : Text, market : Text, limit : Nat, offset : Int) : async PagingArtistDiscographyAlbumObject {
            await* operations__.getAnArtistsAlbums(config, id, includeGroups, market, limit, offset)
        };

        /// Get Artist's Related Artists 
        ///
        /// Get Spotify catalog information about artists similar to a given artist. Similarity is based on analysis of the Spotify community's listening history. 
        public func getAnArtistsRelatedArtists(id : Text) : async GetMultipleArtists200Response {
            await* operations__.getAnArtistsRelatedArtists(config, id)
        };

        /// Get Artist's Top Tracks 
        ///
        /// Get Spotify catalog information about an artist's top tracks by country. 
        public func getAnArtistsTopTracks(id : Text, market : Text) : async GetAnArtistsTopTracks200Response {
            await* operations__.getAnArtistsTopTracks(config, id, market)
        };

        /// Get Followed Artists 
        ///
        /// Get the current user's followed artists. 
        public func getFollowed(type_ : ItemType, after : Text, limit : Nat) : async GetFollowed200Response {
            await* operations__.getFollowed(config, type_, after, limit)
        };

        /// Get Several Artists 
        ///
        /// Get Spotify catalog information for several artists based on their Spotify IDs. 
        public func getMultipleArtists(ids : Text) : async GetMultipleArtists200Response {
            await* operations__.getMultipleArtists(config, ids)
        };

        /// Unfollow Artists or Users 
        ///
        /// Remove the current user as a follower of one or more artists or other Spotify users. 
        public func unfollowArtistsUsers(type_ : ItemType2, ids : Text, unfollowArtistsUsersRequest : UnfollowArtistsUsersRequest) : async () {
            await* operations__.unfollowArtistsUsers(config, type_, ids, unfollowArtistsUsersRequest)
        };

    }
}
