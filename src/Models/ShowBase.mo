
import { type CopyrightObject; JSON = CopyrightObject } "./CopyrightObject";

import { type ExternalUrlObject; JSON = ExternalUrlObject } "./ExternalUrlObject";

import { type ImageObject; JSON = ImageObject } "./ImageObject";

import { type ShowBaseType; JSON = ShowBaseType } "./ShowBaseType";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// ShowBase.mo

module {
    /// The required-fields slice of ShowBase — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
        /// A list of the countries in which the show can be played, identified by their [ISO 3166-1 alpha-2](http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) code. 
        available_markets : [Text];
        /// The copyright statements of the show. 
        copyrights : [CopyrightObject];
        /// A description of the show. HTML tags are stripped away from this field, use `html_description` field in case HTML tags are needed. 
        description : Text;
        /// A description of the show. This field may contain HTML tags. 
        html_description : Text;
        /// Whether or not the show has explicit content (true = yes it does; false = no it does not OR unknown). 
        explicit : Bool;
        /// External URLs for this show. 
        external_urls : ExternalUrlObject;
        /// A link to the Web API endpoint providing full details of the show. 
        href : Text;
        /// The [Spotify ID](/documentation/web-api/concepts/spotify-uris-ids) for the show. 
        id : Text;
        /// The cover art for the show in various sizes, widest first. 
        images : [ImageObject];
        /// True if all of the shows episodes are hosted outside of Spotify's CDN. This field might be `null` in some cases. 
        is_externally_hosted : Bool;
        /// A list of the languages used in the show, identified by their [ISO 639](https://en.wikipedia.org/wiki/ISO_639) code. 
        languages : [Text];
        /// The media type of the show. 
        media_type : Text;
        /// The name of the episode. 
        name : Text;
        /// The publisher of the show. 
        publisher : Text;
        type_ : ShowBaseType;
        /// The [Spotify URI](/documentation/web-api/concepts/spotify-uris-ids) for the show. 
        uri : Text;
        /// The total number of episodes in the show. 
        total_episodes : Int;
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express ShowBase as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
    };

    public type ShowBase = Required and Optional;

    public module JSON {
        // `init` constructs a ShowBase from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { ShowBase.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : ShowBase {
            let ?res = from_candid(to_candid(required)) : ?ShowBase else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : ShowBase) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            List.add(buf, ("available_markets", #Array(Array.map<Text, Candid.Candid>(value.available_markets, func(s : Text) : Candid.Candid = #Text(s)))));
            List.add(buf, ("copyrights", #Array(Array.map<CopyrightObject, Candid.Candid>(value.copyrights, CopyrightObject.toCandidValue))));
            List.add(buf, ("description", #Text(value.description)));
            List.add(buf, ("html_description", #Text(value.html_description)));
            List.add(buf, ("explicit", #Bool(value.explicit)));
            List.add(buf, ("external_urls", ExternalUrlObject.toCandidValue(value.external_urls)));
            List.add(buf, ("href", #Text(value.href)));
            List.add(buf, ("id", #Text(value.id)));
            List.add(buf, ("images", #Array(Array.map<ImageObject, Candid.Candid>(value.images, ImageObject.toCandidValue))));
            List.add(buf, ("is_externally_hosted", #Bool(value.is_externally_hosted)));
            List.add(buf, ("languages", #Array(Array.map<Text, Candid.Candid>(value.languages, func(s : Text) : Candid.Candid = #Text(s)))));
            List.add(buf, ("media_type", #Text(value.media_type)));
            List.add(buf, ("name", #Text(value.name)));
            List.add(buf, ("publisher", #Text(value.publisher)));
            List.add(buf, ("type", ShowBaseType.toCandidValue(value.type_)));
            List.add(buf, ("uri", #Text(value.uri)));
            List.add(buf, ("total_episodes", #Int(value.total_episodes)));
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?ShowBase =
            switch (candid) {
                case (#Record(fields)) {
                    let ?available_markets_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "available_markets") else return null;
                    let ?available_markets = ((switch (available_markets_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<Text>();
                            for (c__ in xs__.values()) {
                                let #Text(s__) = c__ else return null;
                                List.add(buf__, s__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    })) else return null;
                    let ?copyrights_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "copyrights") else return null;
                    let ?copyrights = ((switch (copyrights_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<CopyrightObject>();
                            for (c__ in xs__.values()) {
                                let ?m__ = CopyrightObject.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    })) else return null;
                    let ?description_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "description") else return null;
                    let ?description = ((switch (description_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?html_description_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "html_description") else return null;
                    let ?html_description = ((switch (html_description_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?explicit_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "explicit") else return null;
                    let ?explicit = ((switch (explicit_field.1) { case (#Bool(b)) ?b; case _ null })) else return null;
                    let ?external_urls_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "external_urls") else return null;
                    let ?external_urls = (ExternalUrlObject.fromCandidValue(external_urls_field.1)) else return null;
                    let ?href_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "href") else return null;
                    let ?href = ((switch (href_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?id_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "id") else return null;
                    let ?id = ((switch (id_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?images_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "images") else return null;
                    let ?images = ((switch (images_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<ImageObject>();
                            for (c__ in xs__.values()) {
                                let ?m__ = ImageObject.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    })) else return null;
                    let ?is_externally_hosted_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "is_externally_hosted") else return null;
                    let ?is_externally_hosted = ((switch (is_externally_hosted_field.1) { case (#Bool(b)) ?b; case _ null })) else return null;
                    let ?languages_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "languages") else return null;
                    let ?languages = ((switch (languages_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<Text>();
                            for (c__ in xs__.values()) {
                                let #Text(s__) = c__ else return null;
                                List.add(buf__, s__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    })) else return null;
                    let ?media_type_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "media_type") else return null;
                    let ?media_type = ((switch (media_type_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?name_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "name") else return null;
                    let ?name = ((switch (name_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?publisher_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "publisher") else return null;
                    let ?publisher = ((switch (publisher_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?type__field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "type") else return null;
                    let ?type_ = (ShowBaseType.fromCandidValue(type__field.1)) else return null;
                    let ?uri_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "uri") else return null;
                    let ?uri = ((switch (uri_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?total_episodes_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "total_episodes") else return null;
                    let ?total_episodes = ((switch (total_episodes_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null })) else return null;
                    ?{
                        available_markets;
                        copyrights;
                        description;
                        html_description;
                        explicit;
                        external_urls;
                        href;
                        id;
                        images;
                        is_externally_hosted;
                        languages;
                        media_type;
                        name;
                        publisher;
                        type_;
                        uri;
                        total_episodes;
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
