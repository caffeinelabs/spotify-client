
import { type CategoryObject; JSON = CategoryObject } "./CategoryObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// GetCategories200ResponseCategories.mo

module {
    /// The required-fields slice of GetCategories200ResponseCategories — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
        /// A link to the Web API endpoint returning the full result of the request 
        href : Text;
        /// The maximum number of items in the response (as set in the query or by default). 
        limit : Int;
        /// The offset of the items returned (as set in the query or by default) 
        offset : Int;
        /// The total number of items available to return. 
        total : Int;
        items : [CategoryObject];
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express GetCategories200ResponseCategories as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        next : ?Text;
        previous : ?Text;
    };

    public type GetCategories200ResponseCategories = Required and Optional;

    public module JSON {
        // `init` constructs a GetCategories200ResponseCategories from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { GetCategories200ResponseCategories.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : GetCategories200ResponseCategories {
            let ?res = from_candid(to_candid(required)) : ?GetCategories200ResponseCategories else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : GetCategories200ResponseCategories) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            List.add(buf, ("href", #Text(value.href)));
            List.add(buf, ("limit", #Int(value.limit)));
            switch (value.next) {
                case (?v__) List.add(buf, ("next", #Text(v__)));
                case null ();
            };
            List.add(buf, ("offset", #Int(value.offset)));
            switch (value.previous) {
                case (?v__) List.add(buf, ("previous", #Text(v__)));
                case null ();
            };
            List.add(buf, ("total", #Int(value.total)));
            List.add(buf, ("items", #Array(Array.map<CategoryObject, Candid.Candid>(value.items, CategoryObject.toCandidValue))));
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?GetCategories200ResponseCategories =
            switch (candid) {
                case (#Record(fields)) {
                    let ?href_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "href") else return null;
                    let ?href = ((switch (href_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?limit_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "limit") else return null;
                    let ?limit = ((switch (limit_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null })) else return null;
                    let next : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "next")) {
                        case (?next_field) ((switch (next_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let ?offset_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "offset") else return null;
                    let ?offset = ((switch (offset_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null })) else return null;
                    let previous : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "previous")) {
                        case (?previous_field) ((switch (previous_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let ?total_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "total") else return null;
                    let ?total = ((switch (total_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null })) else return null;
                    let ?items_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "items") else return null;
                    let ?items = ((switch (items_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<CategoryObject>();
                            for (c__ in xs__.values()) {
                                let ?m__ = CategoryObject.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    })) else return null;
                    ?{
                        href;
                        limit;
                        next;
                        offset;
                        previous;
                        total;
                        items;
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
