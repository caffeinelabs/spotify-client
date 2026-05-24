
import { type AudiobookBaseType; JSON = AudiobookBaseType } "./AudiobookBaseType";

import { type AuthorObject; JSON = AuthorObject } "./AuthorObject";

import { type CopyrightObject; JSON = CopyrightObject } "./CopyrightObject";

import { type ExternalUrlObject; JSON = ExternalUrlObject } "./ExternalUrlObject";

import { type ImageObject; JSON = ImageObject } "./ImageObject";

import { type NarratorObject; JSON = NarratorObject } "./NarratorObject";
import { Candid } "mo:serde-core";
import Array "mo:core/Array";
import List "mo:core/List";
import Float "mo:core/Float";
import Runtime "mo:core/Runtime";

// AudiobookObject.mo

module {
    /// The required-fields slice of AudiobookObject — what `init` consumes.
    /// Exposed so callers can write `let req : Required = {...}` if they want
    /// to manipulate the required-only payload independently of the full record.
    public type Required = {
        /// The author(s) for the audiobook. 
        authors : [AuthorObject];
        /// A list of the countries in which the audiobook can be played, identified by their [ISO 3166-1 alpha-2](http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) code. 
        available_markets : [Text];
        /// The copyright statements of the audiobook. 
        copyrights : [CopyrightObject];
        /// A description of the audiobook. HTML tags are stripped away from this field, use `html_description` field in case HTML tags are needed. 
        description : Text;
        /// A description of the audiobook. This field may contain HTML tags. 
        html_description : Text;
        /// Whether or not the audiobook has explicit content (true = yes it does; false = no it does not OR unknown). 
        explicit : Bool;
        /// External URLs for this audiobook. 
        external_urls : ExternalUrlObject;
        /// A link to the Web API endpoint providing full details of the audiobook. 
        href : Text;
        /// The [Spotify ID](/documentation/web-api/concepts/spotify-uris-ids) for the audiobook. 
        id : Text;
        /// The cover art for the audiobook in various sizes, widest first. 
        images : [ImageObject];
        /// A list of the languages used in the audiobook, identified by their [ISO 639](https://en.wikipedia.org/wiki/ISO_639) code. 
        languages : [Text];
        /// The media type of the audiobook. 
        media_type : Text;
        /// The name of the audiobook. 
        name : Text;
        /// The narrator(s) for the audiobook. 
        narrators : [NarratorObject];
        /// The publisher of the audiobook. 
        publisher : Text;
        type_ : AudiobookBaseType;
        /// The [Spotify URI](/documentation/web-api/concepts/spotify-uris-ids) for the audiobook. 
        uri : Text;
        /// The number of chapters in this audiobook. 
        total_chapters : Int;
        /// The chapters of the audiobook. 
        chapters : Candid.Candid;
    };

    // Optional-fields slice. Private — not part of the consumer surface;
    // it's an internal scaffold so we can express AudiobookObject as an
    // `and`-intersection and keep `init` from listing every optional explicitly.
    type Optional = {
        edition : ?Text;
    };

    public type AudiobookObject = Required and Optional;

    public module JSON {
        // `init` constructs a AudiobookObject from just its required fields,
        // defaulting all optional fields to `null`. Pair with record-update
        // syntax to layer in selected optionals:
        //   let req = { AudiobookObject.init { …required fields… } with someOpt = ?… };
        // Implementation uses Candid round-trip — Candid record subtyping fills
        // absent optional fields with null. Costs a few cycles per call (init is
        // not on a hot path) but keeps generated code compact regardless of how
        // many optional fields the model has.
        public func init(required : Required) : AudiobookObject {
            let ?res = from_candid(to_candid(required)) : ?AudiobookObject else Runtime.unreachable();
            res
        };

        public func toCandidValue(value : AudiobookObject) : Candid.Candid {
            let buf = List.empty<(Text, Candid.Candid)>();
            List.add(buf, ("authors", #Array(Array.map<AuthorObject, Candid.Candid>(value.authors, AuthorObject.toCandidValue))));
            List.add(buf, ("available_markets", #Array(Array.map<Text, Candid.Candid>(value.available_markets, func(s : Text) : Candid.Candid = #Text(s)))));
            List.add(buf, ("copyrights", #Array(Array.map<CopyrightObject, Candid.Candid>(value.copyrights, CopyrightObject.toCandidValue))));
            List.add(buf, ("description", #Text(value.description)));
            List.add(buf, ("html_description", #Text(value.html_description)));
            switch (value.edition) {
                case (?v__) List.add(buf, ("edition", #Text(v__)));
                case null ();
            };
            List.add(buf, ("explicit", #Bool(value.explicit)));
            List.add(buf, ("external_urls", ExternalUrlObject.toCandidValue(value.external_urls)));
            List.add(buf, ("href", #Text(value.href)));
            List.add(buf, ("id", #Text(value.id)));
            List.add(buf, ("images", #Array(Array.map<ImageObject, Candid.Candid>(value.images, ImageObject.toCandidValue))));
            List.add(buf, ("languages", #Array(Array.map<Text, Candid.Candid>(value.languages, func(s : Text) : Candid.Candid = #Text(s)))));
            List.add(buf, ("media_type", #Text(value.media_type)));
            List.add(buf, ("name", #Text(value.name)));
            List.add(buf, ("narrators", #Array(Array.map<NarratorObject, Candid.Candid>(value.narrators, NarratorObject.toCandidValue))));
            List.add(buf, ("publisher", #Text(value.publisher)));
            List.add(buf, ("type", AudiobookBaseType.toCandidValue(value.type_)));
            List.add(buf, ("uri", #Text(value.uri)));
            List.add(buf, ("total_chapters", #Int(value.total_chapters)));
            List.add(buf, ("chapters", value.chapters));
            #Record(List.toArray(buf));
        };

        public func fromCandidValue(candid : Candid.Candid) : ?AudiobookObject =
            switch (candid) {
                case (#Record(fields)) {
                    let ?authors_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "authors") else return null;
                    let ?authors = ((switch (authors_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<AuthorObject>();
                            for (c__ in xs__.values()) {
                                let ?m__ = AuthorObject.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    })) else return null;
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
                    let edition : ?Text = switch (Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "edition")) {
                        case (?edition_field) ((switch (edition_field.1) { case (#Text(s)) ?s; case _ null }));
                        case null null;
                    };
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
                    let ?narrators_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "narrators") else return null;
                    let ?narrators = ((switch (narrators_field.1) {
                        case (#Array(xs__)) {
                            let buf__ = List.empty<NarratorObject>();
                            for (c__ in xs__.values()) {
                                let ?m__ = NarratorObject.fromCandidValue(c__) else return null;
                                List.add(buf__, m__);
                            };
                            ?List.toArray(buf__);
                        };
                        case _ null;
                    })) else return null;
                    let ?publisher_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "publisher") else return null;
                    let ?publisher = ((switch (publisher_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?type__field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "type") else return null;
                    let ?type_ = (AudiobookBaseType.fromCandidValue(type__field.1)) else return null;
                    let ?uri_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "uri") else return null;
                    let ?uri = ((switch (uri_field.1) { case (#Text(s)) ?s; case _ null })) else return null;
                    let ?total_chapters_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "total_chapters") else return null;
                    let ?total_chapters = ((switch (total_chapters_field.1) { case (#Int(i)) ?i; case (#Nat(n)) ?n; case _ null })) else return null;
                    let ?chapters_field = Array.find<(Text, Candid.Candid)>(fields, func((k, _) : (Text, Candid.Candid)) : Bool = k == "chapters") else return null;
                    let ?chapters = (?chapters_field.1) else return null;
                    ?{
                        authors;
                        available_markets;
                        copyrights;
                        description;
                        html_description;
                        edition;
                        explicit;
                        external_urls;
                        href;
                        id;
                        images;
                        languages;
                        media_type;
                        name;
                        narrators;
                        publisher;
                        type_;
                        uri;
                        total_chapters;
                        chapters;
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
