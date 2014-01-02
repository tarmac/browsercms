module Cms
  # Can be added to controllers that allow for Cancel/SaveDraft/Publish
  module PublishWorkflow

    def self.included(klass)
      klass.before_action :only => [:create] do
        redirect_to sitemap_path if canceled?
      end

      klass.before_action :only => [:update] do
        redirect_to polymorphic_path(resource) if canceled?
      end

      klass.before_action :only => [:create, :update] do
        params[resource_param][:publish_on_save] = false if save_draft?
        params[resource_param][:publish_on_save] = true if publish?
      end
    end

    protected

    def canceled?
      params[:commit] == "Cancel"
    end

    def save_draft?
      params[:commit] == "Save Draft"
    end

    def publish?
      params[:commit] == "Publish"
    end
  end
end