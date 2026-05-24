
import { type ContextObject; JSON = ContextObject } "./ContextObject";

import { type DeviceObject; JSON = DeviceObject } "./DeviceObject";

import { type DisallowsObject; JSON = DisallowsObject } "./DisallowsObject";

import { type QueueObjectCurrentlyPlaying; JSON = QueueObjectCurrentlyPlaying } "./QueueObjectCurrentlyPlaying";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// CurrentlyPlayingContextObject.mo

module {
    /// The required-fields slice of CurrentlyPlayingContextObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express CurrentlyPlayingContextObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        device : ?DeviceObject;
        repeat_state : ?Text;
        shuffle_state : ?Bool;
        context : ?ContextObject;
        timestamp : ?Int;
        progress_ms : ?Int;
        is_playing : ?Bool;
        item : ?QueueObjectCurrentlyPlaying;
        currently_playing_type : ?Text;
        actions : ?DisallowsObject;
    };

    public type CurrentlyPlayingContextObject = Required and Optional;

    public module JSON {
        // `init` constructs a CurrentlyPlayingContextObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { CurrentlyPlayingContextObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : CurrentlyPlayingContextObject {
            let ?res = from_candid(to_candid(required)) : ?CurrentlyPlayingContextObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : CurrentlyPlayingContextObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.device) {
                case (?v__) List.add(buf, ("device", DeviceObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.repeat_state) {
                case (?v__) List.add(buf, ("repeat_state", #Text(v__)));
                case null ();
            };
            switch (value.shuffle_state) {
                case (?v__) List.add(buf, ("shuffle_state", #Bool(v__)));
                case null ();
            };
            switch (value.context) {
                case (?v__) List.add(buf, ("context", ContextObject.toCandidValue(v__)));
                case null ();
            };
            switch (value.timestamp) {
                case (?v__) List.add(buf, ("timestamp", #Int(v__)));
                case null ();
            };
            switch (value.progress_ms) {
                case (?v__) List.add(buf, ("progress_ms", #Int(v__)));
                case null ();
            };
            switch (value.is_playing) {
                case (?v__) List.add(buf, ("is_playing", #Bool(v__)));
                case null ();
            };
            switch (value.item) {
                case (?v__) List.add(buf, ("item", QueueObjectCurrentlyPlaying.toCandidValue(v__)));
                case null ();
            };
            switch (value.currently_playing_type) {
                case (?v__) List.add(buf, ("currently_playing_type", #Text(v__)));
                case null ();
            };
            switch (value.actions) {
                case (?v__) List.add(buf, ("actions", DisallowsObject.toCandidValue(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?CurrentlyPlayingContextObject =
            switch (candid) {
                case (#Record(fields)) {
                    let device : ?DeviceObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "device")) {
                        case (?device_field) (DeviceObject.fromCandidValue(device_field.1));
                        case null null;
                    };
                    let repeat_state : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "repeat_state")) {
                        case (?repeat_state_field) ((switch (repeat_state_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let shuffle_state : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "shuffle_state")) {
                        case (?shuffle_state_field) ((switch (shuffle_state_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let context : ?ContextObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "context")) {
                        case (?context_field) (ContextObject.fromCandidValue(context_field.1));
                        case null null;
                    };
                    let timestamp : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "timestamp")) {
                        case (?timestamp_field) ((switch (timestamp_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let progress_ms : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "progress_ms")) {
                        case (?progress_ms_field) ((switch (progress_ms_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let is_playing : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "is_playing")) {
                        case (?is_playing_field) ((switch (is_playing_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let item : ?QueueObjectCurrentlyPlaying = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "item")) {
                        case (?item_field) (QueueObjectCurrentlyPlaying.fromCandidValue(item_field.1));
                        case null null;
                    };
                    let currently_playing_type : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "currently_playing_type")) {
                        case (?currently_playing_type_field) ((switch (currently_playing_type_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let actions : ?DisallowsObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "actions")) {
                        case (?actions_field) (DisallowsObject.fromCandidValue(actions_field.1));
                        case null null;
                    };
                    ?{
                        device;
                        repeat_state;
                        shuffle_state;
                        context;
                        timestamp;
                        progress_ms;
                        is_playing;
                        item;
                        currently_playing_type;
                        actions;
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
