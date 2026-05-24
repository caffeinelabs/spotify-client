import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// TimeIntervalObject.mo

module {
    /// The required-fields slice of TimeIntervalObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express TimeIntervalObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        start : ?Float;
        duration : ?Float;
        confidence : ?Float;
    };

    public type TimeIntervalObject = Required and Optional;

    public module JSON {
        // `init` constructs a TimeIntervalObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { TimeIntervalObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : TimeIntervalObject {
            let ?res = from_candid(to_candid(required)) : ?TimeIntervalObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : TimeIntervalObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.start) {
                case (?v__) List.add(buf, ("start", #Float(v__)));
                case null ();
            };
            switch (value.duration) {
                case (?v__) List.add(buf, ("duration", #Float(v__)));
                case null ();
            };
            switch (value.confidence) {
                case (?v__) List.add(buf, ("confidence", #Float(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?TimeIntervalObject =
            switch (candid) {
                case (#Record(fields)) {
                    let start : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "start")) {
                        case (?start_field) ((switch (start_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let duration : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "duration")) {
                        case (?duration_field) ((switch (duration_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let confidence : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "confidence")) {
                        case (?confidence_field) ((switch (confidence_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    ?{
                        start;
                        duration;
                        confidence;
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
