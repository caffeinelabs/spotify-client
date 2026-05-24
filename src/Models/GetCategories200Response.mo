
import { type GetCategories200ResponseCategories; JSON = GetCategories200ResponseCategories } "./GetCategories200ResponseCategories";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// GetCategories200Response.mo

module {
    /// The required-fields slice of GetCategories200Response — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
        categories : GetCategories200ResponseCategories;
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express GetCategories200Response as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
    };

    public type GetCategories200Response = Required and Optional;

    public module JSON {
        // `init` constructs a GetCategories200Response from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { GetCategories200Response.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : GetCategories200Response {
            let ?res = from_candid(to_candid(required)) : ?GetCategories200Response else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : GetCategories200Response) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            List.add(buf, ("categories", GetCategories200ResponseCategories.toCandidValue(value.categories)));
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?GetCategories200Response =
            switch (candid) {
                case (#Record(fields)) {
                    let ?categories_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "categories") else return null;
                    let ?categories = (GetCategories200ResponseCategories.fromCandidValue(categories_field.1)) else return null;
                    ?{
                        categories;
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
