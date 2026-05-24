
import { type ExternalUrlObject; JSON = ExternalUrlObject } "./ExternalUrlObject";

import { type PublicUserObjectType; JSON = PublicUserObjectType } "./PublicUserObjectType";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// PlaylistOwnerObject.mo

module {
    /// The required-fields slice of PlaylistOwnerObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express PlaylistOwnerObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        external_urls : ?ExternalUrlObject;
        href : ?Text;
        id : ?Text;
        type_ : ?PublicUserObjectType;
        uri : ?Text;
        display_name : ?Text;
    };

    public type PlaylistOwnerObject = Required and Optional;

    public module JSON {
        // `init` constructs a PlaylistOwnerObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { PlaylistOwnerObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : PlaylistOwnerObject {
            let ?res = from_candid(to_candid(required)) : ?PlaylistOwnerObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : PlaylistOwnerObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
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
            switch (value.type_) {
                case (?v__) List.add(buf, ("type", PublicUserObjectType.toCandidValue(v__)));
                case null ();
            };
            switch (value.uri) {
                case (?v__) List.add(buf, ("uri", #Text(v__)));
                case null ();
            };
            switch (value.display_name) {
                case (?v__) List.add(buf, ("display_name", #Text(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?PlaylistOwnerObject =
            switch (candid) {
                case (#Record(fields)) {
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
                    let type_ : ?PublicUserObjectType = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "type")) {
                        case (?type__field) (PublicUserObjectType.fromCandidValue(type__field.1));
                        case null null;
                    };
                    let uri : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "uri")) {
                        case (?uri_field) ((switch (uri_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let display_name : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "display_name")) {
                        case (?display_name_field) ((switch (display_name_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    ?{
                        external_urls;
                        href;
                        id;
                        type_;
                        uri;
                        display_name;
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
