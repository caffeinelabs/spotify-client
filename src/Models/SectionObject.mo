
import { type SectionObjectMode; JSON = SectionObjectMode } "./SectionObjectMode";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";
import Int "mo:core/Int";

// SectionObject.mo

module {
    /// The required-fields slice of SectionObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express SectionObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        start : ?Float;
        duration : ?Float;
        confidence : ?Float;
        loudness : ?Float;
        tempo : ?Float;
        tempo_confidence : ?Float;
        key : ?Int;
        key_confidence : ?Float;
        mode : ?SectionObjectMode;
        mode_confidence : ?Float;
        time_signature : ?Nat;
        time_signature_confidence : ?Float;
    };

    public type SectionObject = Required and Optional;

    public module JSON {
        // `init` constructs a SectionObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { SectionObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : SectionObject {
            let ?res = from_candid(to_candid(required)) : ?SectionObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : SectionObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.start) {
                case (?v__) List.add(buf, ("start", #Float(v__)));
                case null ();
            };
            switch (value.duration) {
                case (?v__) List.add(buf, ("duration", #Float(v__)));
                case null ();
            };
            switch (value.confidence) {
                case (?v__) List.add(buf, ("confidence", #Float(v__)));
                case null ();
            };
            switch (value.loudness) {
                case (?v__) List.add(buf, ("loudness", #Float(v__)));
                case null ();
            };
            switch (value.tempo) {
                case (?v__) List.add(buf, ("tempo", #Float(v__)));
                case null ();
            };
            switch (value.tempo_confidence) {
                case (?v__) List.add(buf, ("tempo_confidence", #Float(v__)));
                case null ();
            };
            switch (value.key) {
                case (?v__) List.add(buf, ("key", #Int(v__)));
                case null ();
            };
            switch (value.key_confidence) {
                case (?v__) List.add(buf, ("key_confidence", #Float(v__)));
                case null ();
            };
            switch (value.mode) {
                case (?v__) List.add(buf, ("mode", SectionObjectMode.toCandidValue(v__)));
                case null ();
            };
            switch (value.mode_confidence) {
                case (?v__) List.add(buf, ("mode_confidence", #Float(v__)));
                case null ();
            };
            switch (value.time_signature) {
                case (?v__) List.add(buf, ("time_signature", #Nat(v__)));
                case null ();
            };
            switch (value.time_signature_confidence) {
                case (?v__) List.add(buf, ("time_signature_confidence", #Float(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?SectionObject =
            switch (candid) {
                case (#Record(fields)) {
                    let start : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "start")) {
                        case (?start_field) ((switch (start_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let duration : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "duration")) {
                        case (?duration_field) ((switch (duration_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let confidence : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "confidence")) {
                        case (?confidence_field) ((switch (confidence_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let loudness : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "loudness")) {
                        case (?loudness_field) ((switch (loudness_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let tempo : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "tempo")) {
                        case (?tempo_field) ((switch (tempo_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let tempo_confidence : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "tempo_confidence")) {
                        case (?tempo_confidence_field) ((switch (tempo_confidence_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let key : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "key")) {
                        case (?key_field) ((switch (key_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let key_confidence : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "key_confidence")) {
                        case (?key_confidence_field) ((switch (key_confidence_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let mode : ?SectionObjectMode = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "mode")) {
                        case (?mode_field) (SectionObjectMode.fromCandidValue(mode_field.1));
                        case null null;
                    };
                    let mode_confidence : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "mode_confidence")) {
                        case (?mode_confidence_field) ((switch (mode_confidence_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let time_signature : ?Nat = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "time_signature")) {
                        case (?time_signature_field) ((switch (time_signature_field.1) { case (#Nat(n)) ?n; case (#Int(i)) (if (i < 0) null else ?Int.abs(i)); case _ null }));
                        case null null;
                    };
                    let time_signature_confidence : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "time_signature_confidence")) {
                        case (?time_signature_confidence_field) ((switch (time_signature_confidence_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    ?{
                        start;
                        duration;
                        confidence;
                        loudness;
                        tempo;
                        tempo_confidence;
                        key;
                        key_confidence;
                        mode;
                        mode_confidence;
                        time_signature;
                        time_signature_confidence;
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
