
import { type ExternalUrlObject; JSON = ExternalUrlObject } "./ExternalUrlObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// ContextObject.mo

module {
    /// The required-fields slice of ContextObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express ContextObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        type_ : ?Text;
        href : ?Text;
        external_urls : ?ExternalUrlObject;
        uri : ?Text;
    };

    public type ContextObject = Required and Optional;

    public module JSON {
        // `init` constructs a ContextObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { ContextObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : ContextObject {
            let ?res = from_candid(to_candid(required)) : ?ContextObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : ContextObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.type_) {
                case (?v__) List.add(buf, ("type", #Text(v__)));
                case null ();
            };
            switch (value.href) {
                case (?v__) List.add(buf, ("href", #Text(v__)));
                case null ();
            };
            switch (value.external_urls) {
                case (?v__) List.add(buf, ("external_urls", ExternalUrlObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.uri) {
                case (?v__) List.add(buf, ("uri", #Text(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?ContextObject =
            switch (candid) {
                case (#Record(fields)) {
                    let type_ : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "type")) {
                        case (?type__field) ((switch (type__field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let href : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "href")) {
                        case (?href_field) ((switch (href_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let external_urls : ?ExternalUrlObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "external_urls")) {
                        case (?external_urls_field) (ExternalUrlObject.fromCandidValue(external_urls_field.1));
                        case null null;
                    };
                    let uri : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "uri")) {
                        case (?uri_field) ((switch (uri_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    ?{
                        type_;
                        href;
                        external_urls;
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
