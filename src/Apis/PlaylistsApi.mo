// PlaylistsApi.mo

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
import { type AddTracksToPlaylistRequest; JSON = AddTracksToPlaylistRequest } "../Models/AddTracksToPlaylistRequest";
import { type ChangePlaylistDetailsRequest; JSON = ChangePlaylistDetailsRequest } "../Models/ChangePlaylistDetailsRequest";
import { type CreatePlaylistRequest; JSON = CreatePlaylistRequest } "../Models/CreatePlaylistRequest";
import { type FollowPlaylistRequest; JSON = FollowPlaylistRequest } "../Models/FollowPlaylistRequest";
import { type GetAnAlbum401Response; JSON = GetAnAlbum401Response } "../Models/GetAnAlbum401Response";
import { type ImageObject; JSON = ImageObject } "../Models/ImageObject";
import { type PagingFeaturedPlaylistObject; JSON = PagingFeaturedPlaylistObject } "../Models/PagingFeaturedPlaylistObject";
import { type PagingPlaylistObject; JSON = PagingPlaylistObject } "../Models/PagingPlaylistObject";
import { type PagingPlaylistTrackObject; JSON = PagingPlaylistTrackObject } "../Models/PagingPlaylistTrackObject";
import { type PlaylistObject; JSON = PlaylistObject } "../Models/PlaylistObject";
import { type RemoveTracksPlaylistRequest; JSON = RemoveTracksPlaylistRequest } "../Models/RemoveTracksPlaylistRequest";
import { type ReorderOrReplacePlaylistsTracks200Response; JSON = ReorderOrReplacePlaylistsTracks200Response } "../Models/ReorderOrReplacePlaylistsTracks200Response";
import { type ReorderOrReplacePlaylistsTracksRequest; JSON = ReorderOrReplacePlaylistsTracksRequest } "../Models/ReorderOrReplacePlaylistsTracksRequest";
import { type Config } "../Config";

module {
    let http_request = (actor "aaaaa-aa" : actor { http_request : (HttpRequestArgs) -> async HttpRequestResult }).http_request;


    /// Add Items to Playlist 
    ///
    /// Add one or more items to a user's playlist. 
    public func addTracksToPlaylist(config : Config, playlistId : Text, position : Int, uris : Text, addTracksToPlaylistRequest : AddTracksToPlaylistRequest) : async* ReorderOrReplacePlaylistsTracks200Response {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/playlists/{playlist_id}/tracks"
            |> Text.replace(_, #text "{playlist_id}", playlistId)
            # "?" # "position=" # Int.toText(position) # "&" # "uris=" # uris;

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
            method = #post;
            headers;
            body = do ? {
                let candidValue : Candid.Candid = AddTracksToPlaylistRequest.toCandidValue(addTracksToPlaylistRequest);
                let #ok(jsonText) = JSON.fromCandid(candidValue)
                    else throw Error.reject("Failed to serialize body to JSON");
                Text.encodeUtf8(jsonText)
            };
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
            (switch (ReorderOrReplacePlaylistsTracks200Response.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to ReorderOrReplacePlaylistsTracks200Response");
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

    /// Change Playlist Details 
    ///
    /// Change a playlist's name and public/private state. (The user must, of course, own the playlist.) 
    public func changePlaylistDetails(config : Config, playlistId : Text, changePlaylistDetailsRequest : ChangePlaylistDetailsRequest) : async* () {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/playlists/{playlist_id}"
            |> Text.replace(_, #text "{playlist_id}", playlistId);

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
                let candidValue : Candid.Candid = ChangePlaylistDetailsRequest.toCandidValue(changePlaylistDetailsRequest);
                let #ok(jsonText) = JSON.fromCandid(candidValue)
                    else throw Error.reject("Failed to serialize body to JSON");
                Text.encodeUtf8(jsonText)
            };
        };

        // Call the management canister's http_request method with cycles
        ignore await (with cycles) http_request(request);

    };

    /// Check if Current User Follows Playlist 
    ///
    /// Check to see if the current user is following a specified playlist. 
    public func checkIfUserFollowsPlaylist(config : Config, playlistId : Text, ids : Text) : async* [Bool] {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/playlists/{playlist_id}/followers/contains"
            |> Text.replace(_, #text "{playlist_id}", playlistId)
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

    /// Create Playlist 
    ///
    /// Create a playlist for a Spotify user. (The playlist will be empty until you [add tracks](/documentation/web-api/reference/add-tracks-to-playlist).) Each user is generally limited to a maximum of 11000 playlists. 
    public func createPlaylist(config : Config, userId : Text, createPlaylistRequest : CreatePlaylistRequest) : async* PlaylistObject {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/users/{user_id}/playlists"
            |> Text.replace(_, #text "{user_id}", userId);

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
            method = #post;
            headers;
            body = do ? {
                let candidValue : Candid.Candid = CreatePlaylistRequest.toCandidValue(createPlaylistRequest);
                let #ok(jsonText) = JSON.fromCandid(candidValue)
                    else throw Error.reject("Failed to serialize body to JSON");
                Text.encodeUtf8(jsonText)
            };
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
            (switch (PlaylistObject.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to PlaylistObject");
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

    /// Follow Playlist 
    ///
    /// Add the current user as a follower of a playlist. 
    public func followPlaylist(config : Config, playlistId : Text, followPlaylistRequest : FollowPlaylistRequest) : async* () {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/playlists/{playlist_id}/followers"
            |> Text.replace(_, #text "{playlist_id}", playlistId);

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
                let candidValue : Candid.Candid = FollowPlaylistRequest.toCandidValue(followPlaylistRequest);
                let #ok(jsonText) = JSON.fromCandid(candidValue)
                    else throw Error.reject("Failed to serialize body to JSON");
                Text.encodeUtf8(jsonText)
            };
        };

        // Call the management canister's http_request method with cycles
        ignore await (with cycles) http_request(request);

    };

    /// Get Category's Playlists 
    ///
    /// Get a list of Spotify playlists tagged with a particular category. 
    public func getACategoriesPlaylists(config : Config, categoryId : Text, limit : Nat, offset : Int) : async* PagingFeaturedPlaylistObject {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/browse/categories/{category_id}/playlists"
            |> Text.replace(_, #text "{category_id}", categoryId)
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
            (switch (PagingFeaturedPlaylistObject.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to PagingFeaturedPlaylistObject");
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

    /// Get Current User's Playlists 
    ///
    /// Get a list of the playlists owned or followed by the current Spotify user. 
    public func getAListOfCurrentUsersPlaylists(config : Config, limit : Nat, offset : Int) : async* PagingPlaylistObject {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/me/playlists"
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
            (switch (PagingPlaylistObject.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to PagingPlaylistObject");
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

    /// Get Featured Playlists 
    ///
    /// Get a list of Spotify featured playlists (shown, for example, on a Spotify player's 'Browse' tab). 
    public func getFeaturedPlaylists(config : Config, locale : Text, limit : Nat, offset : Int) : async* PagingFeaturedPlaylistObject {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/browse/featured-playlists"
            # "?" # "locale=" # locale # "&" # "limit=" # Int.toText(limit) # "&" # "offset=" # Int.toText(offset);

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
            (switch (PagingFeaturedPlaylistObject.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to PagingFeaturedPlaylistObject");
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

    /// Get User's Playlists 
    ///
    /// Get a list of the playlists owned or followed by a Spotify user. 
    public func getListUsersPlaylists(config : Config, userId : Text, limit : Nat, offset : Int) : async* PagingPlaylistObject {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/users/{user_id}/playlists"
            |> Text.replace(_, #text "{user_id}", userId)
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
            (switch (PagingPlaylistObject.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to PagingPlaylistObject");
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

    /// Get Playlist 
    ///
    /// Get a playlist owned by a Spotify user. 
    public func getPlaylist(config : Config, playlistId : Text, market : Text, fields : Text, additionalTypes : Text) : async* PlaylistObject {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/playlists/{playlist_id}"
            |> Text.replace(_, #text "{playlist_id}", playlistId)
            # "?" # "market=" # market # "&" # "fields=" # fields # "&" # "additional_types=" # additionalTypes;

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
            (switch (PlaylistObject.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to PlaylistObject");
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

    /// Get Playlist Cover Image 
    ///
    /// Get the current image associated with a specific playlist. 
    public func getPlaylistCover(config : Config, playlistId : Text) : async* [ImageObject] {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/playlists/{playlist_id}/images"
            |> Text.replace(_, #text "{playlist_id}", playlistId);

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
                    let buf__ = List.empty<ImageObject>();
                    for (c__ in xs__.values()) {
                        let ?v__ = ImageObject.fromCandidValue(c__) else throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert array element to ImageObject");
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

    /// Get Playlist Items 
    ///
    /// Get full details of the items of a playlist owned by a Spotify user. 
    public func getPlaylistsTracks(config : Config, playlistId : Text, market : Text, fields : Text, limit : Nat, offset : Int, additionalTypes : Text) : async* PagingPlaylistTrackObject {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/playlists/{playlist_id}/tracks"
            |> Text.replace(_, #text "{playlist_id}", playlistId)
            # "?" # "market=" # market # "&" # "fields=" # fields # "&" # "limit=" # Int.toText(limit) # "&" # "offset=" # Int.toText(offset) # "&" # "additional_types=" # additionalTypes;

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
            (switch (PagingPlaylistTrackObject.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to PagingPlaylistTrackObject");
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

    /// Remove Playlist Items 
    ///
    /// Remove one or more items from a user's playlist. 
    public func removeTracksPlaylist(config : Config, playlistId : Text, removeTracksPlaylistRequest : RemoveTracksPlaylistRequest) : async* ReorderOrReplacePlaylistsTracks200Response {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/playlists/{playlist_id}/tracks"
            |> Text.replace(_, #text "{playlist_id}", playlistId);

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
                let candidValue : Candid.Candid = RemoveTracksPlaylistRequest.toCandidValue(removeTracksPlaylistRequest);
                let #ok(jsonText) = JSON.fromCandid(candidValue)
                    else throw Error.reject("Failed to serialize body to JSON");
                Text.encodeUtf8(jsonText)
            };
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
            (switch (ReorderOrReplacePlaylistsTracks200Response.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to ReorderOrReplacePlaylistsTracks200Response");
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

    /// Update Playlist Items 
    ///
    /// Either reorder or replace items in a playlist depending on the request's parameters. To reorder items, include `range_start`, `insert_before`, `range_length` and `snapshot_id` in the request's body. To replace items, include `uris` as either a query parameter or in the request's body. Replacing items in a playlist will overwrite its existing items. This operation can be used for replacing or clearing items in a playlist. <br/> **Note**: Replace and reorder are mutually exclusive operations which share the same endpoint, but have different parameters. These operations can't be applied together in a single request. 
    public func reorderOrReplacePlaylistsTracks(config : Config, playlistId : Text, uris : Text, reorderOrReplacePlaylistsTracksRequest : ReorderOrReplacePlaylistsTracksRequest) : async* ReorderOrReplacePlaylistsTracks200Response {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/playlists/{playlist_id}/tracks"
            |> Text.replace(_, #text "{playlist_id}", playlistId)
            # "?" # "uris=" # uris;

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
                let candidValue : Candid.Candid = ReorderOrReplacePlaylistsTracksRequest.toCandidValue(reorderOrReplacePlaylistsTracksRequest);
                let #ok(jsonText) = JSON.fromCandid(candidValue)
                    else throw Error.reject("Failed to serialize body to JSON");
                Text.encodeUtf8(jsonText)
            };
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
            (switch (ReorderOrReplacePlaylistsTracks200Response.fromCandidValue(_)) {
                case (?value) value;
                case null throw Error.reject("HTTP " # Int.toText(response.status) # ": Failed to convert response to ReorderOrReplacePlaylistsTracks200Response");
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

    /// Unfollow Playlist 
    ///
    /// Remove the current user as a follower of a playlist. 
    public func unfollowPlaylist(config : Config, playlistId : Text) : async* () {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/playlists/{playlist_id}/followers"
            |> Text.replace(_, #text "{playlist_id}", playlistId);

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
            body = null;
        };

        // Call the management canister's http_request method with cycles
        ignore await (with cycles) http_request(request);

    };

    /// Add Custom Playlist Cover Image 
    ///
    /// Replace the image used to represent a specific playlist. 
    public func uploadCustomPlaylistCover(config : Config, playlistId : Text, body : Blob) : async* () {
        // x-server-override (set by spec-merge per input) pins this
        // operation to the right host for multi-spec merged clients;
        // when absent we use config.baseUrl as before.
        let {baseUrl; cycles} = config;
        let baseUrl__ = baseUrl # "/playlists/{playlist_id}/images"
            |> Text.replace(_, #text "{playlist_id}", playlistId);

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
                let candidValue : Candid.Candid = #Text(body);
                let #ok(jsonText) = JSON.fromCandid(candidValue)
                    else throw Error.reject("Failed to serialize body to JSON");
                Text.encodeUtf8(jsonText)
            };
        };

        // Call the management canister's http_request method with cycles
        ignore await (with cycles) http_request(request);

    };


    let operations__ = {
        addTracksToPlaylist;
        changePlaylistDetails;
        checkIfUserFollowsPlaylist;
        createPlaylist;
        followPlaylist;
        getACategoriesPlaylists;
        getAListOfCurrentUsersPlaylists;
        getFeaturedPlaylists;
        getListUsersPlaylists;
        getPlaylist;
        getPlaylistCover;
        getPlaylistsTracks;
        removeTracksPlaylist;
        reorderOrReplacePlaylistsTracks;
        unfollowPlaylist;
        uploadCustomPlaylistCover;
    };

    public module class PlaylistsApi(config : Config) {
        /// Add Items to Playlist 
        ///
        /// Add one or more items to a user's playlist. 
        public func addTracksToPlaylist(playlistId : Text, position : Int, uris : Text, addTracksToPlaylistRequest : AddTracksToPlaylistRequest) : async ReorderOrReplacePlaylistsTracks200Response {
            await* operations__.addTracksToPlaylist(config, playlistId, position, uris, addTracksToPlaylistRequest)
        };

        /// Change Playlist Details 
        ///
        /// Change a playlist's name and public/private state. (The user must, of course, own the playlist.) 
        public func changePlaylistDetails(playlistId : Text, changePlaylistDetailsRequest : ChangePlaylistDetailsRequest) : async () {
            await* operations__.changePlaylistDetails(config, playlistId, changePlaylistDetailsRequest)
        };

        /// Check if Current User Follows Playlist 
        ///
        /// Check to see if the current user is following a specified playlist. 
        public func checkIfUserFollowsPlaylist(playlistId : Text, ids : Text) : async [Bool] {
            await* operations__.checkIfUserFollowsPlaylist(config, playlistId, ids)
        };

        /// Create Playlist 
        ///
        /// Create a playlist for a Spotify user. (The playlist will be empty until you [add tracks](/documentation/web-api/reference/add-tracks-to-playlist).) Each user is generally limited to a maximum of 11000 playlists. 
        public func createPlaylist(userId : Text, createPlaylistRequest : CreatePlaylistRequest) : async PlaylistObject {
            await* operations__.createPlaylist(config, userId, createPlaylistRequest)
        };

        /// Follow Playlist 
        ///
        /// Add the current user as a follower of a playlist. 
        public func followPlaylist(playlistId : Text, followPlaylistRequest : FollowPlaylistRequest) : async () {
            await* operations__.followPlaylist(config, playlistId, followPlaylistRequest)
        };

        /// Get Category's Playlists 
        ///
        /// Get a list of Spotify playlists tagged with a particular category. 
        public func getACategoriesPlaylists(categoryId : Text, limit : Nat, offset : Int) : async PagingFeaturedPlaylistObject {
            await* operations__.getACategoriesPlaylists(config, categoryId, limit, offset)
        };

        /// Get Current User's Playlists 
        ///
        /// Get a list of the playlists owned or followed by the current Spotify user. 
        public func getAListOfCurrentUsersPlaylists(limit : Nat, offset : Int) : async PagingPlaylistObject {
            await* operations__.getAListOfCurrentUsersPlaylists(config, limit, offset)
        };

        /// Get Featured Playlists 
        ///
        /// Get a list of Spotify featured playlists (shown, for example, on a Spotify player's 'Browse' tab). 
        public func getFeaturedPlaylists(locale : Text, limit : Nat, offset : Int) : async PagingFeaturedPlaylistObject {
            await* operations__.getFeaturedPlaylists(config, locale, limit, offset)
        };

        /// Get User's Playlists 
        ///
        /// Get a list of the playlists owned or followed by a Spotify user. 
        public func getListUsersPlaylists(userId : Text, limit : Nat, offset : Int) : async PagingPlaylistObject {
            await* operations__.getListUsersPlaylists(config, userId, limit, offset)
        };

        /// Get Playlist 
        ///
        /// Get a playlist owned by a Spotify user. 
        public func getPlaylist(playlistId : Text, market : Text, fields : Text, additionalTypes : Text) : async PlaylistObject {
            await* operations__.getPlaylist(config, playlistId, market, fields, additionalTypes)
        };

        /// Get Playlist Cover Image 
        ///
        /// Get the current image associated with a specific playlist. 
        public func getPlaylistCover(playlistId : Text) : async [ImageObject] {
            await* operations__.getPlaylistCover(config, playlistId)
        };

        /// Get Playlist Items 
        ///
        /// Get full details of the items of a playlist owned by a Spotify user. 
        public func getPlaylistsTracks(playlistId : Text, market : Text, fields : Text, limit : Nat, offset : Int, additionalTypes : Text) : async PagingPlaylistTrackObject {
            await* operations__.getPlaylistsTracks(config, playlistId, market, fields, limit, offset, additionalTypes)
        };

        /// Remove Playlist Items 
        ///
        /// Remove one or more items from a user's playlist. 
        public func removeTracksPlaylist(playlistId : Text, removeTracksPlaylistRequest : RemoveTracksPlaylistRequest) : async ReorderOrReplacePlaylistsTracks200Response {
            await* operations__.removeTracksPlaylist(config, playlistId, removeTracksPlaylistRequest)
        };

        /// Update Playlist Items 
        ///
        /// Either reorder or replace items in a playlist depending on the request's parameters. To reorder items, include `range_start`, `insert_before`, `range_length` and `snapshot_id` in the request's body. To replace items, include `uris` as either a query parameter or in the request's body. Replacing items in a playlist will overwrite its existing items. This operation can be used for replacing or clearing items in a playlist. <br/> **Note**: Replace and reorder are mutually exclusive operations which share the same endpoint, but have different parameters. These operations can't be applied together in a single request. 
        public func reorderOrReplacePlaylistsTracks(playlistId : Text, uris : Text, reorderOrReplacePlaylistsTracksRequest : ReorderOrReplacePlaylistsTracksRequest) : async ReorderOrReplacePlaylistsTracks200Response {
            await* operations__.reorderOrReplacePlaylistsTracks(config, playlistId, uris, reorderOrReplacePlaylistsTracksRequest)
        };

        /// Unfollow Playlist 
        ///
        /// Remove the current user as a follower of a playlist. 
        public func unfollowPlaylist(playlistId : Text) : async () {
            await* operations__.unfollowPlaylist(config, playlistId)
        };

        /// Add Custom Playlist Cover Image 
        ///
        /// Replace the image used to represent a specific playlist. 
        public func uploadCustomPlaylistCover(playlistId : Text, body : Blob) : async () {
            await* operations__.uploadCustomPlaylistCover(config, playlistId, body)
        };

    }
}
