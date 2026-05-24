import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// RecommendationSeedObject.mo

module {
    /// The required-fields slice of RecommendationSeedObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express RecommendationSeedObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        afterFilteringSize : ?Int;
        afterRelinkingSize : ?Int;
        href : ?Text;
        id : ?Text;
        initialPoolSize : ?Int;
        type_ : ?Text;
    };

    public type RecommendationSeedObject = Required and Optional;

    public module JSON {
        // `init` constructs a RecommendationSeedObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { RecommendationSeedObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : RecommendationSeedObject {
            let ?res = from_candid(to_candid(required)) : ?RecommendationSeedObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : RecommendationSeedObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.afterFilteringSize) {
                case (?v__) List.add(buf, ("afterFilteringSize", #Int(v__)));
                case null ();
            };
            switch (value.afterRelinkingSize) {
                case (?v__) List.add(buf, ("afterRelinkingSize", #Int(v__)));
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
            switch (value.initialPoolSize) {
                case (?v__) List.add(buf, ("initialPoolSize", #Int(v__)));
                case null ();
            };
            switch (value.type_) {
                case (?v__) List.add(buf, ("type", #Text(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?RecommendationSeedObject =
            switch (candid) {
                case (#Record(fields)) {
                    let afterFilteringSize : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "afterFilteringSize")) {
                        case (?afterFilteringSize_field) ((switch (afterFilteringSize_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let afterRelinkingSize : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "afterRelinkingSize")) {
                        case (?afterRelinkingSize_field) ((switch (afterRelinkingSize_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
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
                    let initialPoolSize : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "initialPoolSize")) {
                        case (?initialPoolSize_field) ((switch (initialPoolSize_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let type_ : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "type")) {
                        case (?type__field) ((switch (type__field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    ?{
                        afterFilteringSize;
                        afterRelinkingSize;
                        href;
                        id;
                        initialPoolSize;
                        type_;
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
