import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";
import Int "mo:core/Int";

// DeviceObject.mo

module {
    /// The required-fields slice of DeviceObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express DeviceObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        id : ?Text;
        is_active : ?Bool;
        is_private_session : ?Bool;
        is_restricted : ?Bool;
        name : ?Text;
        type_ : ?Text;
        volume_percent : ?Nat;
        supports_volume : ?Bool;
    };

    public type DeviceObject = Required and Optional;

    public module JSON {
        // `init` constructs a DeviceObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { DeviceObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : DeviceObject {
            let ?res = from_candid(to_candid(required)) : ?DeviceObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : DeviceObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            switch (value.id) {
                case (?v__) List.add(buf, ("id", #Text(v__)));
                case null ();
            };
            switch (value.is_active) {
                case (?v__) List.add(buf, ("is_active", #Bool(v__)));
                case null ();
            };
            switch (value.is_private_session) {
                case (?v__) List.add(buf, ("is_private_session", #Bool(v__)));
                case null ();
            };
            switch (value.is_restricted) {
                case (?v__) List.add(buf, ("is_restricted", #Bool(v__)));
                case null ();
            };
            switch (value.name) {
                case (?v__) List.add(buf, ("name", #Text(v__)));
                case null ();
            };
            switch (value.type_) {
                case (?v__) List.add(buf, ("type", #Text(v__)));
                case null ();
            };
            switch (value.volume_percent) {
                case (?v__) List.add(buf, ("volume_percent", #Nat(v__)));
                case null ();
            };
            switch (value.supports_volume) {
                case (?v__) List.add(buf, ("supports_volume", #Bool(v__)));
                case null ();
            };
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?DeviceObject =
            switch (candid) {
                case (#Record(fields)) {
                    let id : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "id")) {
                        case (?id_field) ((switch (id_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let is_active : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "is_active")) {
                        case (?is_active_field) ((switch (is_active_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let is_private_session : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "is_private_session")) {
                        case (?is_private_session_field) ((switch (is_private_session_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let is_restricted : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "is_restricted")) {
                        case (?is_restricted_field) ((switch (is_restricted_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    let name : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "name")) {
                        case (?name_field) ((switch (name_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let type_ : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "type")) {
                        case (?type__field) ((switch (type__field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
                    let volume_percent : ?Nat = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "volume_percent")) {
                        case (?volume_percent_field) ((switch (volume_percent_field.1) { case (#Nat(n)) ?n; case (#Int(i)) (if (i < 0) null else ?Int.abs(i)); case _ null }));
                        case null null;
                    };
                    let supports_volume : ?Bool = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "supports_volume")) {
                        case (?supports_volume_field) ((switch (supports_volume_field.1) { case (#Bool(b)) ?b; case _ null }));
                        case null null;
                    };
                    ?{
                        id;
                        is_active;
                        is_private_session;
                        is_restricted;
                        name;
                        type_;
                        volume_percent;
                        supports_volume;
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
