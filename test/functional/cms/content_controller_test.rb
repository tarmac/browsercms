require File.join(File.dirname(__FILE__), '/../../test_helper')

class Cms::ContentControllerTest < ActionController::TestCase
  include Cms::ControllerTestHelper
  
  def test_show_home_page
    get :show
    assert_response :success
    assert_select "title", "Home"
  end
  
  def test_show_another_page
    @page = Factory(:page, :section => root_section, :path => "/about", :name => "Test About", :template => "Main", :publish_on_save => true)
    get :show, :path => ["about"]
    assert_select "title", "Test About"
  end
  
  def test_show_protected_page_to_guest
    create_protected_page
    
    get :show, :path => ["secret"]
    assert_response :forbidden
    assert_select "title", "Access Denied"
  end
  
  def test_show_protected_page_to_privileged_user
    create_protected_page
    
    login_as @privileged_user
    
    get :show, :path => ["secret"]
    assert_response :success
    assert_select "title", "Shhh... It's a Secret"
  end
  
  def test_show_archived_page_to_guest
    create_archived_page

    get :show, :path => ["archived"]
    assert_response :not_found
    assert_select "title", "Not Found"
  end

  def test_show_archived_page_to_user
    create_archived_page
    login_as_cms_admin

    get :show, :path => ["archived"]
    assert_response :success
    assert_select "title", "Archived"
  end

  def test_show_file
    create_file
    
    get :show, :path => ["test.txt"]
    
    assert_response :success
    assert_equal "text/plain", @response.content_type
    assert_equal "This is a test", streaming_file_contents
  end
  
  def test_show_archived_file
    create_file
    
    reset(:file_block)
    @file_block.update_attributes(:archived => true)
    reset(:file_block)
    assert @file_block.attachment.archived?
    
    get :show, :path => ["test.txt"]
    
    assert_response :not_found
    assert_select "title", "Not Found"
  end
  
  def test_show_protected_file_to_guest
    create_protected_file
    
    get :show, :path => ["test.txt"]
    
    assert_response :forbidden
    assert_select "title", "Access Denied"
  end
  
  def test_show_protected_file_to_privileged_user
    create_protected_file
    login_as @privileged_user
    
    get :show, :path => ["test.txt"]
    
    assert_response :success
    assert_equal "text/plain", @response.content_type
    assert_equal "This is a test", streaming_file_contents
  end
  
  protected
    def create_protected_user_section_group
      @protected_section = Factory(:section, :parent => root_section)
      @secret_group = Factory(:group, :name => "Secret")
      @secret_group.sections << @protected_section
      @privileged_user = Factory(:user, :login => "privileged")
      @privileged_user.groups << @secret_group      
    end
  
    def create_protected_page
      create_protected_user_section_group      
      @page = Factory(:page, 
        :section => @protected_section, 
        :path => "/secret", 
        :name => "Shhh... It's a Secret", 
        :template => "Main", 
        :publish_on_save => true)
    end
  
    def create_file
      @file = mock_file(:read => "This is a test", :content_type => "text/plain")
      @file_block = Factory(:file_block, :attachment_section => root_section, :attachment_file => @file, :attachment_file_path => "/test.txt", :publish_on_save => true)      
    end
    
    def create_protected_file
      create_protected_user_section_group      
      create_file
      reset(:file_block)
      @file_block.update_attributes(:attachment_section => @protected_section)
      reset(:file_block)
    end
  
    def create_archived_page
      @page = Factory(:page, 
        :section => root_section, 
        :path => "/archived", 
        :name => "Archived", 
        :archived => true, 
        :template => "Main", 
        :publish_on_save => true)
    end
  
end
