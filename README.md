# Traitify

Traitify is a ruby gem wrapper for the Traitify Developer's API

## Installation

Add this line to your Gemfile (using bundler):

    gem 'traitify'

Or install it yourself with:

    gem install traitify

## Usage

First it is helpful to configure Traitify, otherwise everytime you create a Traitify object you must add the configuration

### Configuration

All the configuration options can be found in `lib/Traitify/configuration.rb`

    Traitify.configure do |tom|
      tom.secret = "secret"
      tom.api_host = "http://example.com"
      tom.api_version = "v1"
      tom.deck_id = "deck-uuid"
    end

#### With config file:

    tom = Traitify.new
    tom.create_assessment

#### Without config file:

    tom = Traitify.new(api_host: "http://example.com", api_version: "v1", deck_id: "deck-uuid", secret: "secret")
    tom.create_assessment

### Users

#### Creating a user:

    user = tom.create_user(
      first_name: "Tom",
      last_name: "Prats",
      email: "tom@tomprats.com"
    )

Returns a user object:

    user.id         #=> "toms-uuid"
    user.first_name #=> "Tom"
    user.last_name  #=> "Prats"
    user.email      #=> "tom@tomprats.com"

#### Finding a user:

    tom.find_user("toms-uuid")

Returns a user object as seen above

### Assessments

#### Creating an assessment:

    assessment = tom.create_assessment

You can also pass a user id to tie it to a user

    assessment = tom.create_assessment(user_id: "toms-uuid")

You must can specify the deck in your configuration or override it here

    assessment = tom.create_assessment(deck_id: "deck-uuid")

Returns an assessment object:

    assessment.id           #=> "assessment-uuid"
    assessment.deck_id      #=> "deck-uuid"
    assessment.user_id      #=> "toms-uuid"
    assessment.created_at   #=> 46197-10-17 12:29:08 -0400
    assessment.completed_at #=> nil

#### Finding an assessment:

    assessment = tom.find_assessment("assessment-uuid")

Returns an assessment object as seen above

#### Taking an assessment:

An assessment can be taken through our javascript plugin or by getting the slides and iterating through them

#### Finding an assessment's slides:

    slides = tom.find_slides("assessment_id")

Returns a slides object which has the assessment id but also functions as an array

    slides.assessment_id #=> "assessment-uuid"
    slides.first         #=> Slide object
    slides.all           #=> Array of slide objects

#### Updating an assessment's slides:

    slides.all.map! do |slide|
      # true for me, false for not me
      slide.response = true
      # Pass in the time it took to make that choice (milliseconds)
      slide.time_taken = 600
      slide
    end

    tom.update_slides(slides)

#### Updating a single assessment slide:

    slide = assessment.slides.first
    slide.response = true
    slide.time_taken = 600
    slides.first = tom.update_slide(assessment.id, slide)

Or with a hash

    assessment.slides.first = tom.update_slide(
      assessment_id: assessment.id,
      slide_id:      assessment.slides.first.id,
      response:      0,
      time_taken:    600
    )


### Results

#### Getting an assessment's results

    results = tom.find_results("assessment-uuid")

Returns a results object:

    results.personality_blend #=> Personality blend object
    results.personality_types #=> Array of personality type objects (with scores)

    personality_blend = results.personality_blend
    personality_blend.personality_type1                     #=> Personality type object (without score)
    personality_blend.personality_type2                     #=> Personality type object (without score)
    personality_blend.name                                  #=> "Visionary Creator"
    personality_blend.description                           #=> "Visionary Creator description"
    personality_blend.compliments                           #=> "Visionary Creator compliments"
    personality_blend.conflicts                             #=> "Visionary Creator conflicts"
    personality_blend.compatible_work_environment_1         #=> "Example text here"
    personality_blend.compatible_work_environment_2         #=> "Example text here"
    personality_blend.compatible_work_environment_3         #=> "Example text here"
    personality_blend.compatible_work_environment_4         #=> "Example text here"

    personality_type = results.personality_types.first
    personality_type.name        #=> "Creator"
    personality_type.description #=> "Creator description"
    personality_type.badge       #=> Badge object
    personality_type.score       #=> 100

    badge = personality_type.badge
    badge.image_small  #=> "http://s3.amazonaws.com/traitify-api/badges/creator/flat/small"
    badge.image_medium #=> "http://s3.amazonaws.com/traitify-api/badges/creator/flat/medium"
    badge.image_large  #=> "http://s3.amazonaws.com/traitify-api/badges/creator/flat/large"
