
import { type AudioFeaturesObjectType; JSON = AudioFeaturesObjectType } "./AudioFeaturesObjectType";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";
import Int "mo:core/Int";

// AudioFeaturesObject.mo

module {
    /// The required-fields slice of AudioFeaturesObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express AudioFeaturesObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        acousticness : ?Float;
        analysis_url : ?Text;
        danceability : ?Float;
        duration_ms : ?Int;
        energy : ?Float;
        id : ?Text;
        instrumentalness : ?Float;
        key : ?Int;
        liveness : ?Float;
        loudness : ?Float;
        mode : ?Int;
        speechiness : ?Float;
        tempo : ?Float;
        time_signature : ?Nat;
        track_href : ?Text;
        type_ : ?AudioFeaturesObjectType;
        uri : ?Text;
        valence : ?Float;
    };

    public type AudioFeaturesObject = Required and Optional;

    public module JSON {
        // `init` constructs a AudioFeaturesObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { AudioFeaturesObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : AudioFeaturesObject {
            let ?res = from_candid(to_candid(required)) : ?AudioFeaturesObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : AudioFeaturesObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.acousticness) {
                case (?v__) List.add(buf, ("acousticness", #Float(v__)));
                case null ();
            };
            switch (value.analysis_url) {
                case (?v__) List.add(buf, ("analysis_url", #Text(v__)));
                case null ();
            };
            switch (value.danceability) {
                case (?v__) List.add(buf, ("danceability", #Float(v__)));
                case null ();
            };
            switch (value.duration_ms) {
                case (?v__) List.add(buf, ("duration_ms", #Int(v__)));
                case null ();
            };
            switch (value.energy) {
                case (?v__) List.add(buf, ("energy", #Float(v__)));
                case null ();
            };
            switch (value.id) {
                case (?v__) List.add(buf, ("id", #Text(v__)));
                case null ();
            };
            switch (value.instrumentalness) {
                case (?v__) List.add(buf, ("instrumentalness", #Float(v__)));
                case null ();
            };
            switch (value.key) {
                case (?v__) List.add(buf, ("key", #Int(v__)));
                case null ();
            };
            switch (value.liveness) {
                case (?v__) List.add(buf, ("liveness", #Float(v__)));
                case null ();
            };
            switch (value.loudness) {
                case (?v__) List.add(buf, ("loudness", #Float(v__)));
                case null ();
            };
            switch (value.mode) {
                case (?v__) List.add(buf, ("mode", #Int(v__)));
                case null ();
            };
            switch (value.speechiness) {
                case (?v__) List.add(buf, ("speechiness", #Float(v__)));
                case null ();
            };
            switch (value.tempo) {
                case (?v__) List.add(buf, ("tempo", #Float(v__)));
                case null ();
            };
            switch (value.time_signature) {
                case (?v__) List.add(buf, ("time_signature", #Nat(v__)));
                case null ();
            };
            switch (value.track_href) {
                case (?v__) List.add(buf, ("track_href", #Text(v__)));
                case null ();
            };
            switch (value.type_) {
                case (?v__) List.add(buf, ("type", AudioFeaturesObjectType.toCandidValue(v__)));
                case null ();
            };
            switch (value.uri) {
                case (?v__) List.add(buf, ("uri", #Text(v__)));
                case null ();
            };
            switch (value.valence) {
                case (?v__) List.add(buf, ("valence", #Float(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?AudioFeaturesObject =
            switch (candid) {
                case (#Record(fields)) {
                    let acousticness : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "acousticness")) {
                        case (?acousticness_field) ((switch (acousticness_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let analysis_url : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "analysis_url")) {
                        case (?analysis_url_field) ((switch (analysis_url_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let danceability : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "danceability")) {
                        case (?danceability_field) ((switch (danceability_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let duration_ms : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "duration_ms")) {
                        case (?duration_ms_field) ((switch (duration_ms_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let energy : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "energy")) {
                        case (?energy_field) ((switch (energy_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let id : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "id")) {
                        case (?id_field) ((switch (id_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let instrumentalness : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "instrumentalness")) {
                        case (?instrumentalness_field) ((switch (instrumentalness_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let key : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "key")) {
                        case (?key_field) ((switch (key_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let liveness : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "liveness")) {
                        case (?liveness_field) ((switch (liveness_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let loudness : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "loudness")) {
                        case (?loudness_field) ((switch (loudness_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let mode : ?Int = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "mode")) {
                        case (?mode_field) ((switch (mode_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null }));
                        case null null;
                    };
                    let speechiness : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "speechiness")) {
                        case (?speechiness_field) ((switch (speechiness_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let tempo : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "tempo")) {
                        case (?tempo_field) ((switch (tempo_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    let time_signature : ?Nat = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "time_signature")) {
                        case (?time_signature_field) ((switch (time_signature_field.1) { case (#Nat(n)) ?n; case (#Int(i)) (if (i < 0) null else ?Int.abs(i)); case _ null }));
                        case null null;
                    };
                    let track_href : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "track_href")) {
                        case (?track_href_field) ((switch (track_href_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let type_ : ?AudioFeaturesObjectType = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "type")) {
                        case (?type__field) (AudioFeaturesObjectType.fromCandidValue(type__field.1));
                        case null null;
                    };
                    let uri : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "uri")) {
                        case (?uri_field) ((switch (uri_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let valence : ?Float = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "valence")) {
                        case (?valence_field) ((switch (valence_field.1) { case (#Float(f)) ?f; case (#Int(i)) ?Float.fromInt(i); case (#Nat(n)) ?Float.fromInt(n); case _ null }));
                        case null null;
                    };
                    ?{
                        acousticness;
                        analysis_url;
                        danceability;
                        duration_ms;
                        energy;
                        id;
                        instrumentalness;
                        key;
                        liveness;
                        loudness;
                        mode;
                        speechiness;
                        tempo;
                        time_signature;
                        track_href;
                        type_;
                        uri;
                        valence;
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
