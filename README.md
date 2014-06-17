# Traitify

Traitify is a ruby gem wrapper for the Traitify Developer's API

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
      traitify.secret = "secret"
      traitify.api_host = "http://example.com"
      traitify.api_version = "v1"
      traitify.deck_id = "deck-uuid"  # Optional
      traitify.image_pack = "image-pack-type"  # Optional
    end

#### With config file:

    traitify = Traitify.new
    traitify.create_assessment

#### Without config file:

    traitify = Traitify.new(
      api_host: "http://example.com",
      api_version: "v1",
      deck_id: "deck-uuid",
      secret: "secret"
    )
    traitify.create_assessment

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

    assessment = traitify.create_assessment

You must can specify the deck in your configuration or override it here

    assessment = traitify.create_assessment(deck_id: "deck-uuid")

You can also specify an image pack, otherwise a default image pack associated with the secret is used

    assessment = traitify.create_assessment(image_pack: "full-color")

Returns an assessment object:

    assessment.id           #=> "assessment-uuid"
    assessment.deck_id      #=> "deck-uuid"
    assessment.created_at   #=> Returns time in Epoch format
    assessment.completed_at #=> nil

#### Finding an assessment:

    assessment = traitify.find_assessment("assessment-uuid")

Returns an assessment object as seen above

#### Taking an assessment:

An assessment can be taken through our javascript plugin or by getting the slides and iterating through them

#### Finding an assessment's slides:

    slides = traitify.find_slides("assessment-uuid")

Returns an array of slides

#### Updating an assessment's slides:

    slides.map! do |slide|
      # true for me, false for not me
      slide.response = true
      # Pass in the time it took to make that choice (milliseconds)
      slide.time_taken = 600
      slide
    end

    traitify.update_slides("assessment-uuid", slides)

#### Updating a single assessment slide:

    slide = assessment.slides.first
    slide.response = true
    slide.time_taken = 600
    traitify.update_slide(assessment.id, slide)

### Results

#### Getting an assessment's results

    results = traitify.find_results("assessment-uuid")

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

    traits = traitify.assessment_personality_traits("assessment-uuid")
    trait = traits.first
    trait.score #=> 100
    personality_trait = trait.personality_trait
    personality_trait.name        #=> "Imaginative"
    personality_trait.definition  #=> "Able to think symbolically and play with ideas."
    personality_trait.description #=> "Coming Soon"
