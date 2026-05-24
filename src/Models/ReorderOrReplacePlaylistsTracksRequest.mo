import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// ReorderOrReplacePlaylistsTracksRequest.mo

module {
    /// The required-fields slice of ReorderOrReplacePlaylistsTracksRequest — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express ReorderOrReplacePlaylistsTracksRequest as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        uris : ?[Text];
        range_start : ?Int;
        insert_before : ?Int;
        range_length : ?Int;
        snapshot_id : ?Text;
    };

    public type ReorderOrReplacePlaylistsTracksRequest = Required and Optional;

    public module JSON {
        // `init` constructs a ReorderOrReplacePlaylistsTracksRequest from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { ReorderOrReplacePlaylistsTracksRequest.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : ReorderOrReplacePlaylistsTracksRequest {
            let ?res = from_candid(to_candid(required)) : ?ReorderOrReplacePlaylistsTracksRequest else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : ReorderOrReplacePlaylistsTracksRequest) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.uris) {
                case (?v__) List.add(buf, ("uris", #Array(Array.map<Text, Candid.Candid>(v__, func(s : Text) : Candid.Candid = #Text(s)))));
                case null ();
            };
            switch (value.range_start) {
                case (?v__) List.add(buf, ("range_start", #Int(v__)));
                case null ();
            };
            switch (value.insert_before) {
                case (?v__) List.add(buf, ("insert_before", #Int(v__)));
                case null ();
            };
            switch (value.range_length) {
                case (?v__) List.add(buf, ("range_length", #Int(v__)));
                case null ();
            };
            switch (value.snapshot_id) {
                case (?v__) List.add(buf, ("snapshot_id", #Text(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?ReorderOrReplacePlaylistsTracksRequest =
            switch (candid) {
                case (#Record(fields)) {
                    let uris : ?[Text] = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "uris")) {
                        case (?uris_field) ((switch (uris_field.1) {
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
                    let range_start : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "range_start")) {
                        case (?range_start_field) ((switch (range_start_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let insert_before : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "insert_before")) {
                        case (?insert_before_field) ((switch (insert_before_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let range_length : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "range_length")) {
                        case (?range_length_field) ((switch (range_length_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let snapshot_id : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "snapshot_id")) {
                        case (?snapshot_id_field) ((switch (snapshot_id_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    ?{
                        uris;
                        range_start;
                        insert_before;
                        range_length;
                        snapshot_id;
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
