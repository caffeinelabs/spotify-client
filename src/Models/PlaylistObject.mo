
import { type ExternalUrlObject; JSON = ExternalUrlObject } "./ExternalUrlObject";

import { type ImageObject; JSON = ImageObject } "./ImageObject";

import { type PagingPlaylistTrackObject; JSON = PagingPlaylistTrackObject } "./PagingPlaylistTrackObject";

import { type PlaylistOwnerObject; JSON = PlaylistOwnerObject } "./PlaylistOwnerObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// PlaylistObject.mo

module {
    /// The required-fields slice of PlaylistObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express PlaylistObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        collaborative : ?Bool;
        description : ?Text;
        external_urls : ?ExternalUrlObject;
        href : ?Text;
        id : ?Text;
        images : ?[ImageObject];
        name : ?Text;
        owner : ?PlaylistOwnerObject;
        public_ : ?Bool;
        snapshot_id : ?Text;
        tracks : ?PagingPlaylistTrackObject;
        type_ : ?Text;
        uri : ?Text;
    };

    public type PlaylistObject = Required and Optional;

    public module JSON {
        // `init` constructs a PlaylistObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { PlaylistObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : PlaylistObject {
            let ?res = from_candid(to_candid(required)) : ?PlaylistObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : PlaylistObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.collaborative) {
                case (?v__) List.add(buf, ("collaborative", #Bool(v__)));
                case null ();
            };
            switch (value.description) {
                case (?v__) List.add(buf, ("description", #Text(v__)));
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
            switch (value.images) {
                case (?v__) List.add(buf, ("images", #Array(Array.map<ImageObject, Candid.Candid>(v__, ImageObject.toCandidValue))));
                case null ();
            };
            switch (value.name) {
                case (?v__) List.add(buf, ("name", #Text(v__)));
                case null ();
            };
            switch (value.owner) {
                case (?v__) List.add(buf, ("owner", PlaylistOwnerObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.public_) {
                case (?v__) List.add(buf, ("public", #Bool(v__)));
                case null ();
            };
            switch (value.snapshot_id) {
                case (?v__) List.add(buf, ("snapshot_id", #Text(v__)));
                case null ();
            };
            switch (value.tracks) {
                case (?v__) List.add(buf, ("tracks", PagingPlaylistTrackObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.type_) {
                case (?v__) List.add(buf, ("type", #Text(v__)));
                case null ();
            };
            switch (value.uri) {
                case (?v__) List.add(buf, ("uri", #Text(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?PlaylistObject =
            switch (candid) {
                case (#Record(fields)) {
                    let collaborative : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "collaborative")) {
                        case (?collaborative_field) ((switch (collaborative_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let description : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "description")) {
                        case (?description_field) ((switch (description_field.1) { case (#Text(s)) ?s; case _ null }));
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
                    let images : ?[ImageObject] = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "images")) {
                        case (?images_field) ((switch (images_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<ImageObject>();
                            for (c__ in xs__.values()) {
                                let ?m__ = ImageObject.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    }));
                        case null null;
                    };
                    let name : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "name")) {
                        case (?name_field) ((switch (name_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let owner : ?PlaylistOwnerObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "owner")) {
                        case (?owner_field) (PlaylistOwnerObject.fromCandidValue(owner_field.1));
                        case null null;
                    };
                    let public_ : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "public")) {
                        case (?public__field) ((switch (public__field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let snapshot_id : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "snapshot_id")) {
                        case (?snapshot_id_field) ((switch (snapshot_id_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let tracks : ?PagingPlaylistTrackObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "tracks")) {
                        case (?tracks_field) (PagingPlaylistTrackObject.fromCandidValue(tracks_field.1));
                        case null null;
                    };
                    let type_ : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "type")) {
                        case (?type__field) ((switch (type__field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let uri : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "uri")) {
                        case (?uri_field) ((switch (uri_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    ?{
                        collaborative;
                        description;
                        external_urls;
                        href;
                        id;
                        images;
                        name;
                        owner;
                        public_;
                        snapshot_id;
                        tracks;
                        type_;
                        uri;
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
