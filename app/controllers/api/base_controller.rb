module Api
  class BaseController < ApplicationController
    wrap_parameters false

    include ResponseConcern
    include ErrorResponseConcern
  end
end
