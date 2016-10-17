# Traitify

Traitify is a ruby gem wrapper for Traitify's Personality API

## Installation

Add this line to your Gemfile (using bundler):

    gem "traitify"

Or install it yourself with:

    gem install traitify

## Usage

First, it is helpful to configure Traitify, otherwise everytime you create a Traitify object you must add the configuration

### Configuration

All the configuration options can be found in `lib/Traitify/configuration.rb`

    Traitify.configure do |traitify|
      traitify.host = "https://api-sandbox.traitify.com"
      traitify.version = "v1"
      traitify.secret_key = "secret"
      traitify.public_key = "public" # Optional
      traitify.deck_id = "deck-uuid"  # Optional
      traitify.image_pack = "image-pack-type"  # Optional
      traitify.locale_key = "en-us"  # Optional
    end

#### With config file:

    traitify = Traitify.new
    traitify.assessments.create

#### Without config file:

    traitify = Traitify.new(
      host: "https://api-sandbox.traitify.com",
      version: "v1",
      secret_key: "secret",
      deck_id: "deck-uuid"
    )
    traitify.assessments.create

### Decks

#### Getting all the decks:

    decks = traitify.decks

Returns an array of Deck objects:

    deck = decks.first
    deck.id                   #=> "deck-uuid"
    deck.name                 #=> "Career"
    deck.description          #=> "Description of deck"
    # And more

### Assessments

#### Creating an assessment:

    assessment = traitify.assessments.create

You must can specify the deck in your configuration or override it here

    assessment = traitify.assessments.create(deck_id: "deck-uuid")

You can optionally specify image pack or locale

    assessment = traitify.assessments.create(image_pack: "full-color")

Returns an assessment object:

    assessment.id           #=> "assessment-uuid"
    assessment.deck_id      #=> "deck-uuid"
    assessment.created_at   #=> Returns time in Epoch format
    assessment.completed_at #=> nil

#### Finding an assessment:

    assessment = traitify.assessments("assessment-uuid").first

Returns an assessment object as seen above

#### Taking an assessment:

An assessment can be taken through our javascript plugin or by getting the slides and iterating through them

#### Finding an assessment's slides:

    slides = traitify.assessments("assessment-uuid").slides.fetch

Returns an array of slides

#### Updating an assessment's slides:

    slides.map! do |slide|
      # true for me, false for not me
      slide.response = true
      # Pass in the time it took to make that choice (milliseconds)
      slide.time_taken = 600
      slide
    end

    traitify.assessments("assessment-uuid").slides.update(slides)

#### Updating a single assessment slide:

    slide = assessment.slides.first
    slide.response = true
    slide.time_taken = 600
    traitify.assessments(assessment.id).slides(slide.id).update(slide)

### Results

#### Getting an assessment's results

    results = traitify.assessments("assessment-uuid").personality_types

Returns a results object:

    results.personality_blend #=> Personality blend object
    results.personality_types #=> Array of personality type objects (with scores)

    personality_blend = results.personality_blend
    personality_blend.personality_type_1 #=> Personality type object
    personality_blend.personality_type_2 #=> Personality type object
    personality_blend.name               #=> "Visionary Creator"
    personality_blend.description        #=> "Visionary Creator description"
    personality_blend.compliments        #=> "Visionary Creator compliments"
    personality_blend.conflicts          #=> "Visionary Creator conflicts"

    type = results.personality_types.first
    type.score                   #=> 100
    personality_type = type.personality_type
    personality_type.name        #=> "Creator"
    personality_type.description #=> "Creator description"
    personality_type.badge       #=> Badge object

    badge = personality_type.badge
    badge.image_small  #=> "http://s3.amazonaws.com/traitify-api/badges/creator/flat/small"
    badge.image_medium #=> "http://s3.amazonaws.com/traitify-api/badges/creator/flat/medium"
    badge.image_large  #=> "http://s3.amazonaws.com/traitify-api/badges/creator/flat/large"

#### Getting an assessment's personality traits

    traits = traitify.assessments("assessment-uuid").personality_traits.fetch
    trait = traits.first
    trait.score #=> 100
    personality_trait = trait.personality_trait
    personality_trait.name        #=> "Imaginative"
    personality_trait.definition  #=> "Able to think symbolically and play with ideas."
    personality_trait.description #=> "Coming Soon"

#### Getting an assessment's analytics

    traits = traitify.analytics.decks("deck-uuid").personality_traits.fetch
    types = traitify.analytics.decks("deck-uuid").personality_types.fetch
    assessments = traitify.analytics.decks("deck-uuid").assessments.fetch

#### Getting a profile

    profile = traitify.profiles("profile-uuid").fetch
    profile.first_name        #=> "John"
    profile.last_name         #=> "Doe"
    profile.email             #=> "johndoe@example.com"


#### Getting a profile create

    profile = traitify.profiles.create({
        first_name: "John",
        last_name: "Doe",
        email: "johndoe@example.com"
    })

    profile.first_name        #=> "John"
    profile.last_name         #=> "Doe"
    profile.email             #=> "johndoe@example.com"

#### Getting groups

    groups = traitify.groups.fetch

#### Getting a group

    group = traitify.groups("group-uuid").fetch

#### Getting a group create

    groups = traitify.groups.create({
        name: "Example Group",
        category: "Organization",
        profile_ids: ["profile-uuid"],
        group_ids: ["group-uuid"]
    })

#### More results

More API endpoints may be available. You can find more at [developer.traitify.com](http://developer.traitify.com/documentation).
To make authenticated calls to new endpoints use the syntax below:

    traitify.get("/new/endpoint")
    traitify.post("/new/endpoint", { ready: true })
