
import { type PagingArtistObject; JSON = PagingArtistObject } "./PagingArtistObject";

import { type PagingPlaylistObject; JSON = PagingPlaylistObject } "./PagingPlaylistObject";

import { type PagingSimplifiedAlbumObject; JSON = PagingSimplifiedAlbumObject } "./PagingSimplifiedAlbumObject";

import { type PagingSimplifiedAudiobookObject; JSON = PagingSimplifiedAudiobookObject } "./PagingSimplifiedAudiobookObject";

import { type PagingSimplifiedEpisodeObject; JSON = PagingSimplifiedEpisodeObject } "./PagingSimplifiedEpisodeObject";

import { type PagingSimplifiedShowObject; JSON = PagingSimplifiedShowObject } "./PagingSimplifiedShowObject";

import { type PagingTrackObject; JSON = PagingTrackObject } "./PagingTrackObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// Search200Response.mo

module {
    /// The required-fields slice of Search200Response — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express Search200Response as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        tracks : ?PagingTrackObject;
        artists : ?PagingArtistObject;
        albums : ?PagingSimplifiedAlbumObject;
        playlists : ?PagingPlaylistObject;
        shows : ?PagingSimplifiedShowObject;
        episodes : ?PagingSimplifiedEpisodeObject;
        audiobooks : ?PagingSimplifiedAudiobookObject;
    };

    public type Search200Response = Required and Optional;

    public module JSON {
        // `init` constructs a Search200Response from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { Search200Response.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : Search200Response {
            let ?res = from_candid(to_candid(required)) : ?Search200Response else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : Search200Response) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.tracks) {
                case (?v__) List.add(buf, ("tracks", PagingTrackObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.artists) {
                case (?v__) List.add(buf, ("artists", PagingArtistObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.albums) {
                case (?v__) List.add(buf, ("albums", PagingSimplifiedAlbumObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.playlists) {
                case (?v__) List.add(buf, ("playlists", PagingPlaylistObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.shows) {
                case (?v__) List.add(buf, ("shows", PagingSimplifiedShowObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.episodes) {
                case (?v__) List.add(buf, ("episodes", PagingSimplifiedEpisodeObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.audiobooks) {
                case (?v__) List.add(buf, ("audiobooks", PagingSimplifiedAudiobookObject.toCandidValue(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?Search200Response =
            switch (candid) {
                case (#Record(fields)) {
                    let tracks : ?PagingTrackObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "tracks")) {
                        case (?tracks_field) (PagingTrackObject.fromCandidValue(tracks_field.1));
                        case null null;
                    };
                    let artists : ?PagingArtistObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "artists")) {
                        case (?artists_field) (PagingArtistObject.fromCandidValue(artists_field.1));
                        case null null;
                    };
                    let albums : ?PagingSimplifiedAlbumObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "albums")) {
                        case (?albums_field) (PagingSimplifiedAlbumObject.fromCandidValue(albums_field.1));
                        case null null;
                    };
                    let playlists : ?PagingPlaylistObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "playlists")) {
                        case (?playlists_field) (PagingPlaylistObject.fromCandidValue(playlists_field.1));
                        case null null;
                    };
                    let shows : ?PagingSimplifiedShowObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "shows")) {
                        case (?shows_field) (PagingSimplifiedShowObject.fromCandidValue(shows_field.1));
                        case null null;
                    };
                    let episodes : ?PagingSimplifiedEpisodeObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "episodes")) {
                        case (?episodes_field) (PagingSimplifiedEpisodeObject.fromCandidValue(episodes_field.1));
                        case null null;
                    };
                    let audiobooks : ?PagingSimplifiedAudiobookObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "audiobooks")) {
                        case (?audiobooks_field) (PagingSimplifiedAudiobookObject.fromCandidValue(audiobooks_field.1));
                        case null null;
                    };
                    ?{
                        tracks;
                        artists;
                        albums;
                        playlists;
                        shows;
                        episodes;
                        audiobooks;
                    };
                };
                case _ null;
            };
    };

    /// Re-export of `JSON.init` at the outer module level. Three import shapes
    /// all reach the same function:
    ///
    ///   - `import T "...";                                     T.init {…}`     // whole-module
    ///   - `import { type T; JSON = T } "...";                  T.init {…}`     // JSON-alias
    ///   - `import { type T; JSON = T; init = myInit } "...";   myInit {…}`     // explicit rename
    ///
    /// The third form is handy when several models would all be reachable
    /// as `T.init` and you want each bound to a distinct local name.
    public let init = JSON.init;
};
