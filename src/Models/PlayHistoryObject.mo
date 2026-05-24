
import { type ContextObject; JSON = ContextObject } "./ContextObject";

import { type TrackObject; JSON = TrackObject } "./TrackObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// PlayHistoryObject.mo

module {
    /// The required-fields slice of PlayHistoryObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express PlayHistoryObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        track : ?TrackObject;
        played_at : ?Text;
        context : ?ContextObject;
    };

    public type PlayHistoryObject = Required and Optional;

    public module JSON {
        // `init` constructs a PlayHistoryObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { PlayHistoryObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : PlayHistoryObject {
            let ?res = from_candid(to_candid(required)) : ?PlayHistoryObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : PlayHistoryObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.track) {
                case (?v__) List.add(buf, ("track", TrackObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.played_at) {
                case (?v__) List.add(buf, ("played_at", #Text(v__)));
                case null ();
            };
            switch (value.context) {
                case (?v__) List.add(buf, ("context", ContextObject.toCandidValue(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?PlayHistoryObject =
            switch (candid) {
                case (#Record(fields)) {
                    let track : ?TrackObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "track")) {
                        case (?track_field) (TrackObject.fromCandidValue(track_field.1));
                        case null null;
                    };
                    let played_at : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "played_at")) {
                        case (?played_at_field) ((switch (played_at_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let context : ?ContextObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "context")) {
                        case (?context_field) (ContextObject.fromCandidValue(context_field.1));
                        case null null;
                    };
                    ?{
                        track;
                        played_at;
                        context;
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
