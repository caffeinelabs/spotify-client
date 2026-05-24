// EpisodesApi.mo

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
import { type EpisodeObject; JSON = EpisodeObject } "../Models/EpisodeObject";
import { type GetAnAlbum401Response; JSON = GetAnAlbum401Response } "../Models/GetAnAlbum401Response";
import { type GetMultipleEpisodes200Response; JSON = GetMultipleEpisodes200Response } "../Models/GetMultipleEpisodes200Response";
import { type PagingSavedEpisodeObject; JSON = PagingSavedEpisodeObject } "../Models/PagingSavedEpisodeObject";
import { type PagingSimplifiedEpisodeObject; JSON = PagingSimplifiedEpisodeObject } "../Models/PagingSimplifiedEpisodeObject";
import { type RemoveEpisodesUserRequest; JSON = RemoveEpisodesUserRequest } "../Models/RemoveEpisodesUserRequest";
import { type SaveEpisodesUserRequest; JSON = SaveEpisodesUserRequest } "../Models/SaveEpisodesUserRequest";
import { type Config } "../Config";

module {
    let http_request = (actor "aaaaa-aa" : actor { http_request : (HttpRequestArgs) -> async HttpRequestResult }).http_request;


    /// Check User's Saved Episodes 
    ///
    /// Check if one or more episodes is already saved in the current Spotify user's 'Your Episodes' library.<br/> This API endpoint is in __beta__ and could change without warning. Please share any feedback that you have, or issues that you discover, in our [developer community forum](https://community.spotify.com/t5/Spotify-for-Developers/bd-p/Spotify_Developer).. 
    public func checkUsersSavedEpisodes(config : Config, ids : Text) : async* [Bool] {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/me/episodes/contains"
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

    /// Get Show Episodes 
    ///
    /// Get Spotify catalog information about an show’s episodes. Optional parameters can be used to limit the number of episodes returned. 
    public func getAShowsEpisodes(config : Config, id : Text, market : Text, limit : Nat, offset : Int) : async* PagingSimplifiedEpisodeObject {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/shows/{id}/episodes"
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
            (switch (PagingSimplifiedEpisodeObject.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to PagingSimplifiedEpisodeObject");
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

    /// Get Episode 
    ///
    /// Get Spotify catalog information for a single episode identified by its unique Spotify ID. 
    public func getAnEpisode(config : Config, id : Text, market : Text) : async* EpisodeObject {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/episodes/{id}"
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
            (switch (EpisodeObject.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to EpisodeObject");
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

    /// Get Several Episodes 
    ///
    /// Get Spotify catalog information for several episodes based on their Spotify IDs. 
    public func getMultipleEpisodes(config : Config, ids : Text, market : Text) : async* GetMultipleEpisodes200Response {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/episodes"
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
            (switch (GetMultipleEpisodes200Response.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to GetMultipleEpisodes200Response");
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

    /// Get User's Saved Episodes 
    ///
    /// Get a list of the episodes saved in the current Spotify user's library.<br/> This API endpoint is in __beta__ and could change without warning. Please share any feedback that you have, or issues that you discover, in our [developer community forum](https://community.spotify.com/t5/Spotify-for-Developers/bd-p/Spotify_Developer). 
    public func getUsersSavedEpisodes(config : Config, market : Text, limit : Nat, offset : Int) : async* PagingSavedEpisodeObject {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/me/episodes"
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
            (switch (PagingSavedEpisodeObject.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to PagingSavedEpisodeObject");
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

    /// Remove User's Saved Episodes 
    ///
    /// Remove one or more episodes from the current user's library.<br/> This API endpoint is in __beta__ and could change without warning. Please share any feedback that you have, or issues that you discover, in our [developer community forum](https://community.spotify.com/t5/Spotify-for-Developers/bd-p/Spotify_Developer). 
    public func removeEpisodesUser(config : Config, ids : Text, removeEpisodesUserRequest : RemoveEpisodesUserRequest) : async* () {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/me/episodes"
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
                let candidValue : Candid.Candid = RemoveEpisodesUserRequest.toCandidValue(removeEpisodesUserRequest);
                let #ok(jsonText) = JSON.fromCandid(candidValue)
                    else throw Error.reject("Failed to serialize body to JSON");
                Text.encodeUtf8(jsonText)
            };
        };

        // Call the management canister's http_request method with cycles
        ignore await (with cycles) http_request(request);

    };

    /// Save Episodes for Current User 
    ///
    /// Save one or more episodes to the current user's library.<br/> This API endpoint is in __beta__ and could change without warning. Please share any feedback that you have, or issues that you discover, in our [developer community forum](https://community.spotify.com/t5/Spotify-for-Developers/bd-p/Spotify_Developer). 
    public func saveEpisodesUser(config : Config, ids : Text, saveEpisodesUserRequest : SaveEpisodesUserRequest) : async* () {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/me/episodes"
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
                let candidValue : Candid.Candid = SaveEpisodesUserRequest.toCandidValue(saveEpisodesUserRequest);
                let #ok(jsonText) = JSON.fromCandid(candidValue)
                    else throw Error.reject("Failed to serialize body to JSON");
                Text.encodeUtf8(jsonText)
            };
        };

        // Call the management canister's http_request method with cycles
        ignore await (with cycles) http_request(request);

    };


    let operations__ = {
        checkUsersSavedEpisodes;
        getAShowsEpisodes;
        getAnEpisode;
        getMultipleEpisodes;
        getUsersSavedEpisodes;
        removeEpisodesUser;
        saveEpisodesUser;
    };

    public module class EpisodesApi(config : Config) {
        /// Check User's Saved Episodes 
        ///
        /// Check if one or more episodes is already saved in the current Spotify user's 'Your Episodes' library.<br/> This API endpoint is in __beta__ and could change without warning. Please share any feedback that you have, or issues that you discover, in our [developer community forum](https://community.spotify.com/t5/Spotify-for-Developers/bd-p/Spotify_Developer).. 
        public func checkUsersSavedEpisodes(ids : Text) : async [Bool] {
            await* operations__.checkUsersSavedEpisodes(config, ids)
        };

        /// Get Show Episodes 
        ///
        /// Get Spotify catalog information about an show’s episodes. Optional parameters can be used to limit the number of episodes returned. 
        public func getAShowsEpisodes(id : Text, market : Text, limit : Nat, offset : Int) : async PagingSimplifiedEpisodeObject {
            await* operations__.getAShowsEpisodes(config, id, market, limit, offset)
        };

        /// Get Episode 
        ///
        /// Get Spotify catalog information for a single episode identified by its unique Spotify ID. 
        public func getAnEpisode(id : Text, market : Text) : async EpisodeObject {
            await* operations__.getAnEpisode(config, id, market)
        };

        /// Get Several Episodes 
        ///
        /// Get Spotify catalog information for several episodes based on their Spotify IDs. 
        public func getMultipleEpisodes(ids : Text, market : Text) : async GetMultipleEpisodes200Response {
            await* operations__.getMultipleEpisodes(config, ids, market)
        };

        /// Get User's Saved Episodes 
        ///
        /// Get a list of the episodes saved in the current Spotify user's library.<br/> This API endpoint is in __beta__ and could change without warning. Please share any feedback that you have, or issues that you discover, in our [developer community forum](https://community.spotify.com/t5/Spotify-for-Developers/bd-p/Spotify_Developer). 
        public func getUsersSavedEpisodes(market : Text, limit : Nat, offset : Int) : async PagingSavedEpisodeObject {
            await* operations__.getUsersSavedEpisodes(config, market, limit, offset)
        };

        /// Remove User's Saved Episodes 
        ///
        /// Remove one or more episodes from the current user's library.<br/> This API endpoint is in __beta__ and could change without warning. Please share any feedback that you have, or issues that you discover, in our [developer community forum](https://community.spotify.com/t5/Spotify-for-Developers/bd-p/Spotify_Developer). 
        public func removeEpisodesUser(ids : Text, removeEpisodesUserRequest : RemoveEpisodesUserRequest) : async () {
            await* operations__.removeEpisodesUser(config, ids, removeEpisodesUserRequest)
        };

        /// Save Episodes for Current User 
        ///
        /// Save one or more episodes to the current user's library.<br/> This API endpoint is in __beta__ and could change without warning. Please share any feedback that you have, or issues that you discover, in our [developer community forum](https://community.spotify.com/t5/Spotify-for-Developers/bd-p/Spotify_Developer). 
        public func saveEpisodesUser(ids : Text, saveEpisodesUserRequest : SaveEpisodesUserRequest) : async () {
            await* operations__.saveEpisodesUser(config, ids, saveEpisodesUserRequest)
        };

    }
}
