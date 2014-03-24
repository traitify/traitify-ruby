# Tomify

Tomify is a ruby gem wrapper for the Traitify Developer's API

## Installation

Add this line to your Gemfile (using bundler):

    gem 'tomify'

Or install it yourself with:

    gem install tomify

## Usage

First it is helpful to configure Tomify, otherwise everytime you create a Tomify object you must add the configuration

### Configuration

All the configuration options can be found in `lib/tomify/configuration.rb`

    Tomify.configure do |tom|
      tom.secret = "secret"
      tom.api_host = "http://example.com"
      tom.api_version = "v1"
      tom.deck_id = "deck-uuid"
    end

#### With config file:

    tom = Tomify.new
    tom.create_assessment

#### Without config file:

    tom = Tomify.new(api_host: "http://example.com", api_version: "v1", deck_id: "deck-uuid", secret: "secret")
    tom.create_assessment

### Users

#### Creating a user:

    user = tom.create_user(
      first_name: "Tom",
      last_name: "Prats",
      email: "tom@tomprats.com"
    )

Returns a user object:

    user.id             #=> "toms-uuid"
    user.first_name     #=> "Tom"
    user.last_name      #=> "Prats"
    user.email          #=> "tom@tomprats.com"

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

    assessment.id             #=> "assessment-uuid"
    assessment.user_id        #=> "toms-uuid"

Which also has many slide objects in an array

    slide = assessment.slides.first
    slide.id             #=> "slide-uuid"
    slide.response       #=> nil
    slide.time_taken     #=> nil

#### Finding an assessment:

    assessment = tom.find_assessment("assessment-uuid")

Returns an assessment object as seen above

#### Taking an assessment:

An assessment can be taken through our javascript plugin or by iterating through an assessment's slides

    assessment.slides.each do |slide|
      # 1 for me, 0 for not me
      slide.response = 0
      # Pass in the time it took to make that choice (milliseconds)
      slide.time_taken = 600
    end

    tom.update_slides(assessment)

A single slide can be updated like so

    slide = assessment.slides.first
    slide.response = 0
    slide.time_taken = 600
    slide = tom.update_slide(assessment.id, slide)

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

    results.overview     #=> "Overview statement based on the results."

Which also has two personality type objects in an array

    personality_type = results.personality_types.first
    personality_type.name           #=> "Creator"
    personality_type.description    #=> "Creator description"
