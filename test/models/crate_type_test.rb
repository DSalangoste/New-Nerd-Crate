require "test_helper"

class CrateTypeTest < ActiveSupport::TestCase
  def setup
    @crate_type = crate_types(:one)
    @category = categories(:one)
    @crate_type.categories << @category
  end

  test "should be valid" do
    assert @crate_type.valid?
  end

  test "name should be present" do
    @crate_type.name = nil
    assert_not @crate_type.valid?
  end

  test "description should be present" do
    @crate_type.description = nil
    assert_not @crate_type.valid?
  end

  test "price should be present and non-negative" do
    @crate_type.price = nil
    assert_not @crate_type.valid?
    
    @crate_type.price = -10
    assert_not @crate_type.valid?
    
    @crate_type.price = 0
    assert @crate_type.valid?
    
    @crate_type.price = 25.99
    assert @crate_type.valid?
  end

  test "should accept valid image formats" do
    # Create a test image file
    file = Tempfile.new(['test_image', '.jpg'])
    file.binmode
    file.write(File.read(Rails.root.join('test', 'fixtures', 'files', 'test_image.jpg')))
    file.rewind
    
    # Attach the image
    @crate_type.image.attach(
      io: file,
      filename: 'test_image.jpg',
      content_type: 'image/jpeg'
    )
    
    assert @crate_type.valid?
    assert @crate_type.image.attached?
  end

  test "should reject invalid image formats" do
    # Create a test PDF file
    file = Tempfile.new(['test_document', '.pdf'])
    file.binmode
    file.write(File.read(Rails.root.join('test', 'fixtures', 'files', 'test_document.pdf')))
    file.rewind
    
    # Try to attach the PDF
    @crate_type.image.attach(
      io: file,
      filename: 'test_document.pdf',
      content_type: 'application/pdf'
    )
    
    assert_not @crate_type.valid?
    assert_includes @crate_type.errors[:image], 'must be a JPEG, PNG or GIF'
  end

  test "should reject oversized images" do
    # Create a large test image file (6MB)
    file = Tempfile.new(['large_image', '.jpg'])
    file.binmode
    file.write('0' * 6.megabytes)
    file.rewind
    
    # Try to attach the large image
    @crate_type.image.attach(
      io: file,
      filename: 'large_image.jpg',
      content_type: 'image/jpeg'
    )
    
    assert_not @crate_type.valid?
    assert_includes @crate_type.errors[:image], 'is too large (maximum 5MB)'
  end

  test "should search by keyword" do
    results = CrateType.search_by_keyword("Gaming")
    assert_includes results, @crate_type
  end

  test "should filter by category" do
    results = CrateType.filter_by_category(@category.id)
    assert_includes results, @crate_type
  end
end
