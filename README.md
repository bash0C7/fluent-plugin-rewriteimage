# fluent-plugin-rewriteimage

## Output

Output filter plugin to rewrite messages from image path(or URL) string to image data.

### Configure Example

````
      type rewriteimage
      add_tag_prefix hoge
      image_source_key image_field
      image_key rewrited_image_field
      base64encode false
````

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## releases

- 2014/01/25 0.0.1 Release gem
