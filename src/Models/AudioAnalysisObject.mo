
import { type AudioAnalysisObjectMeta; JSON = AudioAnalysisObjectMeta } "./AudioAnalysisObjectMeta";

import { type AudioAnalysisObjectTrack; JSON = AudioAnalysisObjectTrack } "./AudioAnalysisObjectTrack";

import { type SectionObject; JSON = SectionObject } "./SectionObject";

import { type SegmentObject; JSON = SegmentObject } "./SegmentObject";

import { type TimeIntervalObject; JSON = TimeIntervalObject } "./TimeIntervalObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// AudioAnalysisObject.mo

module {
    /// The required-fields slice of AudioAnalysisObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express AudioAnalysisObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        meta : ?AudioAnalysisObjectMeta;
        track : ?AudioAnalysisObjectTrack;
        bars : ?[TimeIntervalObject];
        beats : ?[TimeIntervalObject];
        sections : ?[SectionObject];
        segments : ?[SegmentObject];
        tatums : ?[TimeIntervalObject];
    };

    public type AudioAnalysisObject = Required and Optional;

    public module JSON {
        // `init` constructs a AudioAnalysisObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { AudioAnalysisObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : AudioAnalysisObject {
            let ?res = from_candid(to_candid(required)) : ?AudioAnalysisObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : AudioAnalysisObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.meta) {
                case (?v__) List.add(buf, ("meta", AudioAnalysisObjectMeta.toCandidValue(v__)));
                case null ();
            };
            switch (value.track) {
                case (?v__) List.add(buf, ("track", AudioAnalysisObjectTrack.toCandidValue(v__)));
                case null ();
            };
            switch (value.bars) {
                case (?v__) List.add(buf, ("bars", #Array(Array.map<TimeIntervalObject, Candid.Candid>(v__, TimeIntervalObject.toCandidValue))));
                case null ();
            };
            switch (value.beats) {
                case (?v__) List.add(buf, ("beats", #Array(Array.map<TimeIntervalObject, Candid.Candid>(v__, TimeIntervalObject.toCandidValue))));
                case null ();
            };
            switch (value.sections) {
                case (?v__) List.add(buf, ("sections", #Array(Array.map<SectionObject, Candid.Candid>(v__, SectionObject.toCandidValue))));
                case null ();
            };
            switch (value.segments) {
                case (?v__) List.add(buf, ("segments", #Array(Array.map<SegmentObject, Candid.Candid>(v__, SegmentObject.toCandidValue))));
                case null ();
            };
            switch (value.tatums) {
                case (?v__) List.add(buf, ("tatums", #Array(Array.map<TimeIntervalObject, Candid.Candid>(v__, TimeIntervalObject.toCandidValue))));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?AudioAnalysisObject =
            switch (candid) {
                case (#Record(fields)) {
                    let meta : ?AudioAnalysisObjectMeta = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "meta")) {
                        case (?meta_field) (AudioAnalysisObjectMeta.fromCandidValue(meta_field.1));
                        case null null;
                    };
                    let track : ?AudioAnalysisObjectTrack = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "track")) {
                        case (?track_field) (AudioAnalysisObjectTrack.fromCandidValue(track_field.1));
                        case null null;
                    };
                    let bars : ?[TimeIntervalObject] = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "bars")) {
                        case (?bars_field) ((switch (bars_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<TimeIntervalObject>();
                            for (c__ in xs__.values()) {
                                let ?m__ = TimeIntervalObject.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    }));
                        case null null;
                    };
                    let beats : ?[TimeIntervalObject] = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "beats")) {
                        case (?beats_field) ((switch (beats_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<TimeIntervalObject>();
                            for (c__ in xs__.values()) {
                                let ?m__ = TimeIntervalObject.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    }));
                        case null null;
                    };
                    let sections : ?[SectionObject] = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "sections")) {
                        case (?sections_field) ((switch (sections_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<SectionObject>();
                            for (c__ in xs__.values()) {
                                let ?m__ = SectionObject.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    }));
                        case null null;
                    };
                    let segments : ?[SegmentObject] = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "segments")) {
                        case (?segments_field) ((switch (segments_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<SegmentObject>();
                            for (c__ in xs__.values()) {
                                let ?m__ = SegmentObject.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    }));
                        case null null;
                    };
                    let tatums : ?[TimeIntervalObject] = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "tatums")) {
                        case (?tatums_field) ((switch (tatums_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<TimeIntervalObject>();
                            for (c__ in xs__.values()) {
                                let ?m__ = TimeIntervalObject.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    }));
                        case null null;
                    };
                    ?{
                        meta;
                        track;
                        bars;
                        beats;
                        sections;
                        segments;
                        tatums;
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
