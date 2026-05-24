import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// ResumePointObject.mo

module {
    /// The required-fields slice of ResumePointObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express ResumePointObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        fully_played : ?Bool;
        resume_position_ms : ?Int;
    };

    public type ResumePointObject = Required and Optional;

    public module JSON {
        // `init` constructs a ResumePointObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { ResumePointObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : ResumePointObject {
            let ?res = from_candid(to_candid(required)) : ?ResumePointObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : ResumePointObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.fully_played) {
                case (?v__) List.add(buf, ("fully_played", #Bool(v__)));
                case null ();
            };
            switch (value.resume_position_ms) {
                case (?v__) List.add(buf, ("resume_position_ms", #Int(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?ResumePointObject =
            switch (candid) {
                case (#Record(fields)) {
                    let fully_played : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "fully_played")) {
                        case (?fully_played_field) ((switch (fully_played_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let resume_position_ms : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "resume_position_ms")) {
                        case (?resume_position_ms_field) ((switch (resume_position_ms_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    ?{
                        fully_played;
                        resume_position_ms;
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
