require "test_helper"

class HelperTest < ActionView::TestCase
  tests Webpacker::Helper

  attr_reader :request

  def setup
    @request = Class.new do
      def send_early_hints(links) end
      def base_url
        "https://example.com"
      end
    end.new
  end

  def test_asset_pack_path
    assert_equal "/packs/bootstrap-300631c4f0e0f9c865bc.js", asset_pack_path("bootstrap.js")
    assert_equal "/packs/bootstrap-c38deda30895059837cf.css", asset_pack_path("bootstrap.css")

    Webpacker.config.stub :extract_css?, false do
      assert_nil asset_pack_path("bootstrap.css")
      assert_equal "/packs/application-k344a6d59eef8632c9d1.png", asset_pack_path("application.png")
    end
  end

  def test_asset_pack_url
    assert_equal "https://example.com/packs/bootstrap-300631c4f0e0f9c865bc.js", asset_pack_url("bootstrap.js")
    assert_equal "https://example.com/packs/bootstrap-c38deda30895059837cf.css", asset_pack_url("bootstrap.css")

    Webpacker.config.stub :extract_css?, false do
      assert_nil asset_pack_path("bootstrap.css")
      assert_equal "https://example.com/packs/application-k344a6d59eef8632c9d1.png", asset_pack_url("application.png")
    end
  end

  def test_image_pack_tag
    assert_equal \
      "<img alt=\"Edit Entry\" src=\"/packs/application-k344a6d59eef8632c9d1.png\" width=\"16\" height=\"10\" />",
      image_pack_tag("application.png", size: "16x10", alt: "Edit Entry")
  end

  def test_javascript_pack_tag
    assert_equal \
      %(<script src="/packs/bootstrap-300631c4f0e0f9c865bc.js"></script>),
      javascript_pack_tag("bootstrap.js")
  end

  def test_javascript_pack_tag_symbol
    assert_equal \
      %(<script src="/packs/bootstrap-300631c4f0e0f9c865bc.js"></script>),
      javascript_pack_tag(:bootstrap)
  end

  def test_javascript_pack_tag_splat
    assert_equal \
      %(<script src="/packs/bootstrap-300631c4f0e0f9c865bc.js" defer="defer"></script>\n) +
        %(<script src="/packs/application-k344a6d59eef8632c9d1.js" defer="defer"></script>),
      javascript_pack_tag("bootstrap.js", "application.js", defer: true)
  end

  def test_javascript_pack_tag_split_chunks
    assert_equal \
      %(<script src="/packs/vendors~application~bootstrap-c20632e7baf2c81200d3.chunk.js"></script>\n) +
        %(<script src="/packs/vendors~application-e55f2aae30c07fb6d82a.chunk.js"></script>\n) +
        %(<script src="/packs/application-k344a6d59eef8632c9d1.js"></script>),
      javascript_pack_tag("application")
  end

  def test_stylesheet_pack_tag
    assert_equal \
      %(<link rel="stylesheet" media="screen" href="/packs/bootstrap-c38deda30895059837cf.css" />),
      stylesheet_pack_tag("bootstrap.css")
  end

  def test_stylesheet_pack_tag_symbol
    assert_equal \
      %(<link rel="stylesheet" media="screen" href="/packs/bootstrap-c38deda30895059837cf.css" />),
      stylesheet_pack_tag(:bootstrap)
  end

  def test_stylesheet_pack_tag_splat
    assert_equal \
      %(<link rel="stylesheet" media="all" href="/packs/bootstrap-c38deda30895059837cf.css" />\n) +
        %(<link rel="stylesheet" media="all" href="/packs/application-dd6b1cd38bfa093df600.css" />),
      stylesheet_pack_tag("bootstrap.css", "application.css", media: "all")
  end
end
