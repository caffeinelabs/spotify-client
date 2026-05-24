
import { type QueueObjectCurrentlyPlaying; JSON = QueueObjectCurrentlyPlaying } "./QueueObjectCurrentlyPlaying";

import { type QueueObjectQueueInner; JSON = QueueObjectQueueInner } "./QueueObjectQueueInner";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// QueueObject.mo

module {
    /// The required-fields slice of QueueObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express QueueObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        currently_playing : ?QueueObjectCurrentlyPlaying;
        queue : ?[QueueObjectQueueInner];
    };

    public type QueueObject = Required and Optional;

    public module JSON {
        // `init` constructs a QueueObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { QueueObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : QueueObject {
            let ?res = from_candid(to_candid(required)) : ?QueueObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : QueueObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.currently_playing) {
                case (?v__) List.add(buf, ("currently_playing", QueueObjectCurrentlyPlaying.toCandidValue(v__)));
                case null ();
            };
            switch (value.queue) {
                case (?v__) List.add(buf, ("queue", #Array(Array.map<QueueObjectQueueInner, Candid.Candid>(v__, QueueObjectQueueInner.toCandidValue))));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?QueueObject =
            switch (candid) {
                case (#Record(fields)) {
                    let currently_playing : ?QueueObjectCurrentlyPlaying = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "currently_playing")) {
                        case (?currently_playing_field) (QueueObjectCurrentlyPlaying.fromCandidValue(currently_playing_field.1));
                        case null null;
                    };
                    let queue : ?[QueueObjectQueueInner] = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "queue")) {
                        case (?queue_field) ((switch (queue_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<QueueObjectQueueInner>();
                            for (c__ in xs__.values()) {
                                let ?m__ = QueueObjectQueueInner.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    }));
                        case null null;
                    };
                    ?{
                        currently_playing;
                        queue;
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
