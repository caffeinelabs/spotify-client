
import { type SaveTracksUserRequestTimestampedIdsInner; JSON = SaveTracksUserRequestTimestampedIdsInner } "./SaveTracksUserRequestTimestampedIdsInner";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// SaveTracksUserRequest.mo

module {
    /// The required-fields slice of SaveTracksUserRequest — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express SaveTracksUserRequest as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        ids : ?[Text];
        timestamped_ids : ?[SaveTracksUserRequestTimestampedIdsInner];
    };

    public type SaveTracksUserRequest = Required and Optional;

    public module JSON {
        // `init` constructs a SaveTracksUserRequest from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { SaveTracksUserRequest.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : SaveTracksUserRequest {
            let ?res = from_candid(to_candid(required)) : ?SaveTracksUserRequest else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : SaveTracksUserRequest) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.ids) {
                case (?v__) List.add(buf, ("ids", #Array(Array.map<Text, Candid.Candid>(v__, func(s : Text) : Candid.Candid = #Text(s)))));
                case null ();
            };
            switch (value.timestamped_ids) {
                case (?v__) List.add(buf, ("timestamped_ids", #Array(Array.map<SaveTracksUserRequestTimestampedIdsInner, Candid.Candid>(v__, SaveTracksUserRequestTimestampedIdsInner.toCandidValue))));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?SaveTracksUserRequest =
            switch (candid) {
                case (#Record(fields)) {
                    let ids : ?[Text] = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "ids")) {
                        case (?ids_field) ((switch (ids_field.1) {
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
                    let timestamped_ids : ?[SaveTracksUserRequestTimestampedIdsInner] = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "timestamped_ids")) {
                        case (?timestamped_ids_field) ((switch (timestamped_ids_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<SaveTracksUserRequestTimestampedIdsInner>();
                            for (c__ in xs__.values()) {
                                let ?m__ = SaveTracksUserRequestTimestampedIdsInner.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    }));
                        case null null;
                    };
                    ?{
                        ids;
                        timestamped_ids;
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
