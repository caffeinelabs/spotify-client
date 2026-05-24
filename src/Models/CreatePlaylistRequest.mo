import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// CreatePlaylistRequest.mo

module {
    /// The required-fields slice of CreatePlaylistRequest — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
        /// The name for the new playlist, for example `\"Your Coolest Playlist\"`. This name does not need to be unique; a user may have several playlists with the same name. 
        name : Text;
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express CreatePlaylistRequest as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        public_ : ?Bool;
        collaborative : ?Bool;
        description : ?Text;
    };

    public type CreatePlaylistRequest = Required and Optional;

    public module JSON {
        // `init` constructs a CreatePlaylistRequest from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { CreatePlaylistRequest.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : CreatePlaylistRequest {
            let ?res = from_candid(to_candid(required)) : ?CreatePlaylistRequest else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : CreatePlaylistRequest) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            List.add(buf, ("name", #Text(value.name)));
            switch (value.public_) {
                case (?v__) List.add(buf, ("public", #Bool(v__)));
                case null ();
            };
            switch (value.collaborative) {
                case (?v__) List.add(buf, ("collaborative", #Bool(v__)));
                case null ();
            };
            switch (value.description) {
                case (?v__) List.add(buf, ("description", #Text(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?CreatePlaylistRequest =
            switch (candid) {
                case (#Record(fields)) {
                    let ?name_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "name") else return null;
                    let ?name = ((switch (name_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let public_ : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "public")) {
                        case (?public__field) ((switch (public__field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let collaborative : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "collaborative")) {
                        case (?collaborative_field) ((switch (collaborative_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let description : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "description")) {
                        case (?description_field) ((switch (description_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    ?{
                        name;
                        public_;
                        collaborative;
                        description;
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
