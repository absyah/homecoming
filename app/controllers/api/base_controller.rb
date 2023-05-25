module Api
  class BaseController < ApplicationController
    include ResponseConcern
    include ErrorResponseConcern
  end
end
