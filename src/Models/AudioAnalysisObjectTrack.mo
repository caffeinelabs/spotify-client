import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";
import Int "mo:core/Int";

// AudioAnalysisObjectTrack.mo

module {
    /// The required-fields slice of AudioAnalysisObjectTrack — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express AudioAnalysisObjectTrack as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        num_samples : ?Int;
        duration : ?Float;
        sample_md5 : ?Text;
        offset_seconds : ?Int;
        window_seconds : ?Int;
        analysis_sample_rate : ?Int;
        analysis_channels : ?Int;
        end_of_fade_in : ?Float;
        start_of_fade_out : ?Float;
        loudness : ?Float;
        tempo : ?Float;
        tempo_confidence : ?Float;
        time_signature : ?Nat;
        time_signature_confidence : ?Float;
        key : ?Int;
        key_confidence : ?Float;
        mode : ?Int;
        mode_confidence : ?Float;
        codestring : ?Text;
        code_version : ?Float;
        echoprintstring : ?Text;
        echoprint_version : ?Float;
        synchstring : ?Text;
        synch_version : ?Float;
        rhythmstring : ?Text;
        rhythm_version : ?Float;
    };

    public type AudioAnalysisObjectTrack = Required and Optional;

    public module JSON {
        // `init` constructs a AudioAnalysisObjectTrack from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { AudioAnalysisObjectTrack.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : AudioAnalysisObjectTrack {
            let ?res = from_candid(to_candid(required)) : ?AudioAnalysisObjectTrack else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : AudioAnalysisObjectTrack) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.num_samples) {
                case (?v__) List.add(buf, ("num_samples", #Int(v__)));
                case null ();
            };
            switch (value.duration) {
                case (?v__) List.add(buf, ("duration", #Float(v__)));
                case null ();
            };
            switch (value.sample_md5) {
                case (?v__) List.add(buf, ("sample_md5", #Text(v__)));
                case null ();
            };
            switch (value.offset_seconds) {
                case (?v__) List.add(buf, ("offset_seconds", #Int(v__)));
                case null ();
            };
            switch (value.window_seconds) {
                case (?v__) List.add(buf, ("window_seconds", #Int(v__)));
                case null ();
            };
            switch (value.analysis_sample_rate) {
                case (?v__) List.add(buf, ("analysis_sample_rate", #Int(v__)));
                case null ();
            };
            switch (value.analysis_channels) {
                case (?v__) List.add(buf, ("analysis_channels", #Int(v__)));
                case null ();
            };
            switch (value.end_of_fade_in) {
                case (?v__) List.add(buf, ("end_of_fade_in", #Float(v__)));
                case null ();
            };
            switch (value.start_of_fade_out) {
                case (?v__) List.add(buf, ("start_of_fade_out", #Float(v__)));
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
            switch (value.time_signature) {
                case (?v__) List.add(buf, ("time_signature", #Nat(v__)));
                case null ();
            };
            switch (value.time_signature_confidence) {
                case (?v__) List.add(buf, ("time_signature_confidence", #Float(v__)));
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
                case (?v__) List.add(buf, ("mode", #Int(v__)));
                case null ();
            };
            switch (value.mode_confidence) {
                case (?v__) List.add(buf, ("mode_confidence", #Float(v__)));
                case null ();
            };
            switch (value.codestring) {
                case (?v__) List.add(buf, ("codestring", #Text(v__)));
                case null ();
            };
            switch (value.code_version) {
                case (?v__) List.add(buf, ("code_version", #Float(v__)));
                case null ();
            };
            switch (value.echoprintstring) {
                case (?v__) List.add(buf, ("echoprintstring", #Text(v__)));
                case null ();
            };
            switch (value.echoprint_version) {
                case (?v__) List.add(buf, ("echoprint_version", #Float(v__)));
                case null ();
            };
            switch (value.synchstring) {
                case (?v__) List.add(buf, ("synchstring", #Text(v__)));
                case null ();
            };
            switch (value.synch_version) {
                case (?v__) List.add(buf, ("synch_version", #Float(v__)));
                case null ();
            };
            switch (value.rhythmstring) {
                case (?v__) List.add(buf, ("rhythmstring", #Text(v__)));
                case null ();
            };
            switch (value.rhythm_version) {
                case (?v__) List.add(buf, ("rhythm_version", #Float(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?AudioAnalysisObjectTrack =
            switch (candid) {
                case (#Record(fields)) {
                    let num_samples : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "num_samples")) {
                        case (?num_samples_field) ((switch (num_samples_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let duration : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "duration")) {
                        case (?duration_field) ((switch (duration_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let sample_md5 : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "sample_md5")) {
                        case (?sample_md5_field) ((switch (sample_md5_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let offset_seconds : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "offset_seconds")) {
                        case (?offset_seconds_field) ((switch (offset_seconds_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let window_seconds : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "window_seconds")) {
                        case (?window_seconds_field) ((switch (window_seconds_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let analysis_sample_rate : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "analysis_sample_rate")) {
                        case (?analysis_sample_rate_field) ((switch (analysis_sample_rate_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let analysis_channels : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "analysis_channels")) {
                        case (?analysis_channels_field) ((switch (analysis_channels_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let end_of_fade_in : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "end_of_fade_in")) {
                        case (?end_of_fade_in_field) ((switch (end_of_fade_in_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let start_of_fade_out : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "start_of_fade_out")) {
                        case (?start_of_fade_out_field) ((switch (start_of_fade_out_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
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
                    let time_signature : ?Nat = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "time_signature")) {
                        case (?time_signature_field) ((switch (time_signature_field.1) { case (#Nat(n)) ?n; case (#Int(i)) (if (i < 0) null else ?Int.abs(i)); case _ null }));
                        case null null;
                    };
                    let time_signature_confidence : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "time_signature_confidence")) {
                        case (?time_signature_confidence_field) ((switch (time_signature_confidence_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
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
                    let mode : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "mode")) {
                        case (?mode_field) ((switch (mode_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let mode_confidence : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "mode_confidence")) {
                        case (?mode_confidence_field) ((switch (mode_confidence_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let codestring : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "codestring")) {
                        case (?codestring_field) ((switch (codestring_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let code_version : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "code_version")) {
                        case (?code_version_field) ((switch (code_version_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let echoprintstring : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "echoprintstring")) {
                        case (?echoprintstring_field) ((switch (echoprintstring_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let echoprint_version : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "echoprint_version")) {
                        case (?echoprint_version_field) ((switch (echoprint_version_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let synchstring : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "synchstring")) {
                        case (?synchstring_field) ((switch (synchstring_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let synch_version : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "synch_version")) {
                        case (?synch_version_field) ((switch (synch_version_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let rhythmstring : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "rhythmstring")) {
                        case (?rhythmstring_field) ((switch (rhythmstring_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let rhythm_version : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "rhythm_version")) {
                        case (?rhythm_version_field) ((switch (rhythm_version_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    ?{
                        num_samples;
                        duration;
                        sample_md5;
                        offset_seconds;
                        window_seconds;
                        analysis_sample_rate;
                        analysis_channels;
                        end_of_fade_in;
                        start_of_fade_out;
                        loudness;
                        tempo;
                        tempo_confidence;
                        time_signature;
                        time_signature_confidence;
                        key;
                        key_confidence;
                        mode;
                        mode_confidence;
                        codestring;
                        code_version;
                        echoprintstring;
                        echoprint_version;
                        synchstring;
                        synch_version;
                        rhythmstring;
                        rhythm_version;
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
