import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// DisallowsObject.mo

module {
    /// The required-fields slice of DisallowsObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express DisallowsObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        interrupting_playback : ?Bool;
        pausing : ?Bool;
        resuming : ?Bool;
        seeking : ?Bool;
        skipping_next : ?Bool;
        skipping_prev : ?Bool;
        toggling_repeat_context : ?Bool;
        toggling_shuffle : ?Bool;
        toggling_repeat_track : ?Bool;
        transferring_playback : ?Bool;
    };

    public type DisallowsObject = Required and Optional;

    public module JSON {
        // `init` constructs a DisallowsObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { DisallowsObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : DisallowsObject {
            let ?res = from_candid(to_candid(required)) : ?DisallowsObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : DisallowsObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.interrupting_playback) {
                case (?v__) List.add(buf, ("interrupting_playback", #Bool(v__)));
                case null ();
            };
            switch (value.pausing) {
                case (?v__) List.add(buf, ("pausing", #Bool(v__)));
                case null ();
            };
            switch (value.resuming) {
                case (?v__) List.add(buf, ("resuming", #Bool(v__)));
                case null ();
            };
            switch (value.seeking) {
                case (?v__) List.add(buf, ("seeking", #Bool(v__)));
                case null ();
            };
            switch (value.skipping_next) {
                case (?v__) List.add(buf, ("skipping_next", #Bool(v__)));
                case null ();
            };
            switch (value.skipping_prev) {
                case (?v__) List.add(buf, ("skipping_prev", #Bool(v__)));
                case null ();
            };
            switch (value.toggling_repeat_context) {
                case (?v__) List.add(buf, ("toggling_repeat_context", #Bool(v__)));
                case null ();
            };
            switch (value.toggling_shuffle) {
                case (?v__) List.add(buf, ("toggling_shuffle", #Bool(v__)));
                case null ();
            };
            switch (value.toggling_repeat_track) {
                case (?v__) List.add(buf, ("toggling_repeat_track", #Bool(v__)));
                case null ();
            };
            switch (value.transferring_playback) {
                case (?v__) List.add(buf, ("transferring_playback", #Bool(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?DisallowsObject =
            switch (candid) {
                case (#Record(fields)) {
                    let interrupting_playback : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "interrupting_playback")) {
                        case (?interrupting_playback_field) ((switch (interrupting_playback_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let pausing : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "pausing")) {
                        case (?pausing_field) ((switch (pausing_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let resuming : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "resuming")) {
                        case (?resuming_field) ((switch (resuming_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let seeking : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "seeking")) {
                        case (?seeking_field) ((switch (seeking_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let skipping_next : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "skipping_next")) {
                        case (?skipping_next_field) ((switch (skipping_next_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let skipping_prev : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "skipping_prev")) {
                        case (?skipping_prev_field) ((switch (skipping_prev_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let toggling_repeat_context : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "toggling_repeat_context")) {
                        case (?toggling_repeat_context_field) ((switch (toggling_repeat_context_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let toggling_shuffle : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "toggling_shuffle")) {
                        case (?toggling_shuffle_field) ((switch (toggling_shuffle_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let toggling_repeat_track : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "toggling_repeat_track")) {
                        case (?toggling_repeat_track_field) ((switch (toggling_repeat_track_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let transferring_playback : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "transferring_playback")) {
                        case (?transferring_playback_field) ((switch (transferring_playback_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    ?{
                        interrupting_playback;
                        pausing;
                        resuming;
                        seeking;
                        skipping_next;
                        skipping_prev;
                        toggling_repeat_context;
                        toggling_shuffle;
                        toggling_repeat_track;
                        transferring_playback;
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
