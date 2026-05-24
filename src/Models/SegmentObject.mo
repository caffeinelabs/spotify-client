import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// SegmentObject.mo

module {
    /// The required-fields slice of SegmentObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express SegmentObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        start : ?Float;
        duration : ?Float;
        confidence : ?Float;
        loudness_start : ?Float;
        loudness_max : ?Float;
        loudness_max_time : ?Float;
        loudness_end : ?Float;
        pitches : ?[Float];
        timbre : ?[Float];
    };

    public type SegmentObject = Required and Optional;

    public module JSON {
        // `init` constructs a SegmentObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { SegmentObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : SegmentObject {
            let ?res = from_candid(to_candid(required)) : ?SegmentObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : SegmentObject) : Candid.Candid {
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
            switch (value.loudness_start) {
                case (?v__) List.add(buf, ("loudness_start", #Float(v__)));
                case null ();
            };
            switch (value.loudness_max) {
                case (?v__) List.add(buf, ("loudness_max", #Float(v__)));
                case null ();
            };
            switch (value.loudness_max_time) {
                case (?v__) List.add(buf, ("loudness_max_time", #Float(v__)));
                case null ();
            };
            switch (value.loudness_end) {
                case (?v__) List.add(buf, ("loudness_end", #Float(v__)));
                case null ();
            };
            switch (value.pitches) {
                case (?v__) List.add(buf, ("pitches", #Array(Array.map<Float, Candid.Candid>(v__, func(f : Float) : Candid.Candid = #Float(f)))));
                case null ();
            };
            switch (value.timbre) {
                case (?v__) List.add(buf, ("timbre", #Array(Array.map<Float, Candid.Candid>(v__, func(f : Float) : Candid.Candid = #Float(f)))));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?SegmentObject =
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
                    let loudness_start : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "loudness_start")) {
                        case (?loudness_start_field) ((switch (loudness_start_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let loudness_max : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "loudness_max")) {
                        case (?loudness_max_field) ((switch (loudness_max_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let loudness_max_time : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "loudness_max_time")) {
                        case (?loudness_max_time_field) ((switch (loudness_max_time_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let loudness_end : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "loudness_end")) {
                        case (?loudness_end_field) ((switch (loudness_end_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let pitches : ?[Float] = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "pitches")) {
                        case (?pitches_field) ((switch (pitches_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<Float>();
                            for (c__ in xs__.values()) {
                                let ?f__ = (switch (c__) { case (#Float(g)) ?g; case (#Int(j)) ?Float.fromInt(j); case (#Nat(k)) ?Float.fromInt(k); case _ null }) else return null;
                                List.add(buf__, f__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    }));
                        case null null;
                    };
                    let timbre : ?[Float] = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "timbre")) {
                        case (?timbre_field) ((switch (timbre_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<Float>();
                            for (c__ in xs__.values()) {
                                let ?f__ = (switch (c__) { case (#Float(g)) ?g; case (#Int(j)) ?Float.fromInt(j); case (#Nat(k)) ?Float.fromInt(k); case _ null }) else return null;
                                List.add(buf__, f__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    }));
                        case null null;
                    };
                    ?{
                        start;
                        duration;
                        confidence;
                        loudness_start;
                        loudness_max;
                        loudness_max_time;
                        loudness_end;
                        pitches;
                        timbre;
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
