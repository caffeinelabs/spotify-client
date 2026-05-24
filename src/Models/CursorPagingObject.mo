
import { type CursorObject; JSON = CursorObject } "./CursorObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// CursorPagingObject.mo

module {
    /// The required-fields slice of CursorPagingObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express CursorPagingObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        href : ?Text;
        limit : ?Int;
        next : ?Text;
        cursors : ?CursorObject;
        total : ?Int;
    };

    public type CursorPagingObject = Required and Optional;

    public module JSON {
        // `init` constructs a CursorPagingObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { CursorPagingObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : CursorPagingObject {
            let ?res = from_candid(to_candid(required)) : ?CursorPagingObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : CursorPagingObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.href) {
                case (?v__) List.add(buf, ("href", #Text(v__)));
                case null ();
            };
            switch (value.limit) {
                case (?v__) List.add(buf, ("limit", #Int(v__)));
                case null ();
            };
            switch (value.next) {
                case (?v__) List.add(buf, ("next", #Text(v__)));
                case null ();
            };
            switch (value.cursors) {
                case (?v__) List.add(buf, ("cursors", CursorObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.total) {
                case (?v__) List.add(buf, ("total", #Int(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?CursorPagingObject =
            switch (candid) {
                case (#Record(fields)) {
                    let href : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "href")) {
                        case (?href_field) ((switch (href_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let limit : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "limit")) {
                        case (?limit_field) ((switch (limit_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let next : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "next")) {
                        case (?next_field) ((switch (next_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let cursors : ?CursorObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "cursors")) {
                        case (?cursors_field) (CursorObject.fromCandidValue(cursors_field.1));
                        case null null;
                    };
                    let total : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "total")) {
                        case (?total_field) ((switch (total_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    ?{
                        href;
                        limit;
                        next;
                        cursors;
                        total;
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
