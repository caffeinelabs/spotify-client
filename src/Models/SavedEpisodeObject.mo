
import { type EpisodeObject; JSON = EpisodeObject } "./EpisodeObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// SavedEpisodeObject.mo

module {
    /// The required-fields slice of SavedEpisodeObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express SavedEpisodeObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        added_at : ?Text;
        episode : ?EpisodeObject;
    };

    public type SavedEpisodeObject = Required and Optional;

    public module JSON {
        // `init` constructs a SavedEpisodeObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { SavedEpisodeObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : SavedEpisodeObject {
            let ?res = from_candid(to_candid(required)) : ?SavedEpisodeObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : SavedEpisodeObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.added_at) {
                case (?v__) List.add(buf, ("added_at", #Text(v__)));
                case null ();
            };
            switch (value.episode) {
                case (?v__) List.add(buf, ("episode", EpisodeObject.toCandidValue(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?SavedEpisodeObject =
            switch (candid) {
                case (#Record(fields)) {
                    let added_at : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "added_at")) {
                        case (?added_at_field) ((switch (added_at_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let episode : ?EpisodeObject = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "episode")) {
                        case (?episode_field) (EpisodeObject.fromCandidValue(episode_field.1));
                        case null null;
                    };
                    ?{
                        added_at;
                        episode;
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
