
import { type ExternalIdObject; JSON = ExternalIdObject } "./ExternalIdObject";

import { type ExternalUrlObject; JSON = ExternalUrlObject } "./ExternalUrlObject";

import { type SimplifiedAlbumObject; JSON = SimplifiedAlbumObject } "./SimplifiedAlbumObject";

import { type SimplifiedArtistObject; JSON = SimplifiedArtistObject } "./SimplifiedArtistObject";

import { type TrackObjectType; JSON = TrackObjectType } "./TrackObjectType";

import { type TrackRestrictionObject; JSON = TrackRestrictionObject } "./TrackRestrictionObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// TrackObject.mo

module {
    /// The required-fields slice of TrackObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express TrackObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        album : ?SimplifiedAlbumObject;
        artists : ?[SimplifiedArtistObject];
        available_markets : ?[Text];
        disc_number : ?Int;
        duration_ms : ?Int;
        explicit : ?Bool;
        external_ids : ?ExternalIdObject;
        external_urls : ?ExternalUrlObject;
        href : ?Text;
        id : ?Text;
        is_playable : ?Bool;
        linked_from : ?Candid.Candid;
        restrictions : ?TrackRestrictionObject;
        name : ?Text;
        popularity : ?Int;
        preview_url : ?Text;
        track_number : ?Int;
        type_ : ?TrackObjectType;
        uri : ?Text;
        is_local : ?Bool;
    };

    public type TrackObject = Required and Optional;

    public module JSON {
        // `init` constructs a TrackObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { TrackObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : TrackObject {
            let ?res = from_candid(to_candid(required)) : ?TrackObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : TrackObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.album) {
                case (?v__) List.add(buf, ("album", SimplifiedAlbumObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.artists) {
                case (?v__) List.add(buf, ("artists", #Array(Array.map<SimplifiedArtistObject, Candid.Candid>(v__, SimplifiedArtistObject.toCandidValue))));
                case null ();
            };
            switch (value.available_markets) {
                case (?v__) List.add(buf, ("available_markets", #Array(Array.map<Text, Candid.Candid>(v__, func(s : Text) : Candid.Candid = #Text(s)))));
                case null ();
            };
            switch (value.disc_number) {
                case (?v__) List.add(buf, ("disc_number", #Int(v__)));
                case null ();
            };
            switch (value.duration_ms) {
                case (?v__) List.add(buf, ("duration_ms", #Int(v__)));
                case null ();
            };
            switch (value.explicit) {
                case (?v__) List.add(buf, ("explicit", #Bool(v__)));
                case null ();
            };
            switch (value.external_ids) {
                case (?v__) List.add(buf, ("external_ids", ExternalIdObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.external_urls) {
                case (?v__) List.add(buf, ("external_urls", ExternalUrlObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.href) {
                case (?v__) List.add(buf, ("href", #Text(v__)));
                case null ();
            };
            switch (value.id) {
                case (?v__) List.add(buf, ("id", #Text(v__)));
                case null ();
            };
            switch (value.is_playable) {
                case (?v__) List.add(buf, ("is_playable", #Bool(v__)));
                case null ();
            };
            switch (value.linked_from) {
                case (?v__) List.add(buf, ("linked_from", v__));
                case null ();
            };
            switch (value.restrictions) {
                case (?v__) List.add(buf, ("restrictions", TrackRestrictionObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.name) {
                case (?v__) List.add(buf, ("name", #Text(v__)));
                case null ();
            };
            switch (value.popularity) {
                case (?v__) List.add(buf, ("popularity", #Int(v__)));
                case null ();
            };
            switch (value.preview_url) {
                case (?v__) List.add(buf, ("preview_url", #Text(v__)));
                case null ();
            };
            switch (value.track_number) {
                case (?v__) List.add(buf, ("track_number", #Int(v__)));
                case null ();
            };
            switch (value.type_) {
                case (?v__) List.add(buf, ("type", TrackObjectType.toCandidValue(v__)));
                case null ();
            };
            switch (value.uri) {
                case (?v__) List.add(buf, ("uri", #Text(v__)));
                case null ();
            };
            switch (value.is_local) {
                case (?v__) List.add(buf, ("is_local", #Bool(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?TrackObject =
            switch (candid) {
                case (#Record(fields)) {
                    let album : ?SimplifiedAlbumObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "album")) {
                        case (?album_field) (SimplifiedAlbumObject.fromCandidValue(album_field.1));
                        case null null;
                    };
                    let artists : ?[SimplifiedArtistObject] = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "artists")) {
                        case (?artists_field) ((switch (artists_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<SimplifiedArtistObject>();
                            for (c__ in xs__.values()) {
                                let ?m__ = SimplifiedArtistObject.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    }));
                        case null null;
                    };
                    let available_markets : ?[Text] = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "available_markets")) {
                        case (?available_markets_field) ((switch (available_markets_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<Text>();
                            for (c__ in xs__.values()) {
                                let #Text(s__) = c__ else return null;
                                List.add(buf__, s__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    }));
                        case null null;
                    };
                    let disc_number : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "disc_number")) {
                        case (?disc_number_field) ((switch (disc_number_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let duration_ms : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "duration_ms")) {
                        case (?duration_ms_field) ((switch (duration_ms_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let explicit : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "explicit")) {
                        case (?explicit_field) ((switch (explicit_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let external_ids : ?ExternalIdObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "external_ids")) {
                        case (?external_ids_field) (ExternalIdObject.fromCandidValue(external_ids_field.1));
                        case null null;
                    };
                    let external_urls : ?ExternalUrlObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "external_urls")) {
                        case (?external_urls_field) (ExternalUrlObject.fromCandidValue(external_urls_field.1));
                        case null null;
                    };
                    let href : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "href")) {
                        case (?href_field) ((switch (href_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let id : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "id")) {
                        case (?id_field) ((switch (id_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let is_playable : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "is_playable")) {
                        case (?is_playable_field) ((switch (is_playable_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let linked_from : ?Candid.Candid = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "linked_from")) {
                        case (?linked_from_field) (?linked_from_field.1);
                        case null null;
                    };
                    let restrictions : ?TrackRestrictionObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "restrictions")) {
                        case (?restrictions_field) (TrackRestrictionObject.fromCandidValue(restrictions_field.1));
                        case null null;
                    };
                    let name : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "name")) {
                        case (?name_field) ((switch (name_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let popularity : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "popularity")) {
                        case (?popularity_field) ((switch (popularity_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let preview_url : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "preview_url")) {
                        case (?preview_url_field) ((switch (preview_url_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let track_number : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "track_number")) {
                        case (?track_number_field) ((switch (track_number_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let type_ : ?TrackObjectType = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "type")) {
                        case (?type__field) (TrackObjectType.fromCandidValue(type__field.1));
                        case null null;
                    };
                    let uri : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "uri")) {
                        case (?uri_field) ((switch (uri_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let is_local : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "is_local")) {
                        case (?is_local_field) ((switch (is_local_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    ?{
                        album;
                        artists;
                        available_markets;
                        disc_number;
                        duration_ms;
                        explicit;
                        external_ids;
                        external_urls;
                        href;
                        id;
                        is_playable;
                        linked_from;
                        restrictions;
                        name;
                        popularity;
                        preview_url;
                        track_number;
                        type_;
                        uri;
                        is_local;
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
