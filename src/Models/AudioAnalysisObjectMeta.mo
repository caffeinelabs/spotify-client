import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// AudioAnalysisObjectMeta.mo

module {
    /// The required-fields slice of AudioAnalysisObjectMeta — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express AudioAnalysisObjectMeta as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        analyzer_version : ?Text;
        platform : ?Text;
        detailed_status : ?Text;
        status_code : ?Int;
        timestamp : ?Int;
        analysis_time : ?Float;
        input_process : ?Text;
    };

    public type AudioAnalysisObjectMeta = Required and Optional;

    public module JSON {
        // `init` constructs a AudioAnalysisObjectMeta from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { AudioAnalysisObjectMeta.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : AudioAnalysisObjectMeta {
            let ?res = from_candid(to_candid(required)) : ?AudioAnalysisObjectMeta else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : AudioAnalysisObjectMeta) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.analyzer_version) {
                case (?v__) List.add(buf, ("analyzer_version", #Text(v__)));
                case null ();
            };
            switch (value.platform) {
                case (?v__) List.add(buf, ("platform", #Text(v__)));
                case null ();
            };
            switch (value.detailed_status) {
                case (?v__) List.add(buf, ("detailed_status", #Text(v__)));
                case null ();
            };
            switch (value.status_code) {
                case (?v__) List.add(buf, ("status_code", #Int(v__)));
                case null ();
            };
            switch (value.timestamp) {
                case (?v__) List.add(buf, ("timestamp", #Int(v__)));
                case null ();
            };
            switch (value.analysis_time) {
                case (?v__) List.add(buf, ("analysis_time", #Float(v__)));
                case null ();
            };
            switch (value.input_process) {
                case (?v__) List.add(buf, ("input_process", #Text(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?AudioAnalysisObjectMeta =
            switch (candid) {
                case (#Record(fields)) {
                    let analyzer_version : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "analyzer_version")) {
                        case (?analyzer_version_field) ((switch (analyzer_version_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let platform : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "platform")) {
                        case (?platform_field) ((switch (platform_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let detailed_status : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "detailed_status")) {
                        case (?detailed_status_field) ((switch (detailed_status_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let status_code : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "status_code")) {
                        case (?status_code_field) ((switch (status_code_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let timestamp : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "timestamp")) {
                        case (?timestamp_field) ((switch (timestamp_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let analysis_time : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "analysis_time")) {
                        case (?analysis_time_field) ((switch (analysis_time_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let input_process : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "input_process")) {
                        case (?input_process_field) ((switch (input_process_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    ?{
                        analyzer_version;
                        platform;
                        detailed_status;
                        status_code;
                        timestamp;
                        analysis_time;
                        input_process;
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
