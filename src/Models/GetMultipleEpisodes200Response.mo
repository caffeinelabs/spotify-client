
import { type EpisodeObject; JSON = EpisodeObject } "./EpisodeObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// GetMultipleEpisodes200Response.mo

module {
    /// The required-fields slice of GetMultipleEpisodes200Response — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
        episodes : [EpisodeObject];
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express GetMultipleEpisodes200Response as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
    };

    public type GetMultipleEpisodes200Response = Required and Optional;

    public module JSON {
        // `init` constructs a GetMultipleEpisodes200Response from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { GetMultipleEpisodes200Response.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : GetMultipleEpisodes200Response {
            let ?res = from_candid(to_candid(required)) : ?GetMultipleEpisodes200Response else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : GetMultipleEpisodes200Response) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            List.add(buf, ("episodes", #Array(Array.map<EpisodeObject, Candid.Candid>(value.episodes, EpisodeObject.toCandidValue))));
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?GetMultipleEpisodes200Response =
            switch (candid) {
                case (#Record(fields)) {
                    let ?episodes_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "episodes") else return null;
                    let ?episodes = ((switch (episodes_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<EpisodeObject>();
                            for (c__ in xs__.values()) {
                                let ?m__ = EpisodeObject.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    })) else return null;
                    ?{
                        episodes;
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
