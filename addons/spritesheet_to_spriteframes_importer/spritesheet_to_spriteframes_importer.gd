tool
extends EditorImportPlugin

enum Presets { PRESET_DEFAULT }

func get_importer_name():
    return "SpritesheetToSpriteFrames.import"


func get_visible_name():
    return "SpritesheetToSpriteFrames"


func get_priority():
    return 1


func get_import_order():
    return 100


func get_resource_type():
    return "SpriteFrames"


func get_recognized_extensions():
    return ["sheet"]


func get_save_extension():
    return "tres"


func get_preset_count():
    return Presets.size()


func get_preset_name(preset):
    match preset:
        Presets.PRESET_DEFAULT:
            return "Default"

func get_import_options(preset):
    return []
#    [
#        {
#            "name": "is_use_options_written_sheet_file",
#            "type": TYPE_BOOL,
#            "default_value": true,
#        },
#        {
#            "name": "rows",
#            "type": TYPE_INT,
#            "default_value": 0
#        },
#        {
#            "name": "cols",
#            "type": TYPE_INT,
#            "default_value": 0
#        },
#        {
#            "name": "counts",
#            "type": TYPE_INT,
#            "default_value": 0
#        },
#        {
#            "name": "animation_names",
#            "type": TYPE_STRING_ARRAY,
#            "default_value": [''],
#        },
#    ]

func get_option_visibility(option, options):
    return true

var _sp_frames:SpriteFrames

func import(source_file, save_path, options, platform_v, r_gen_files):
    var img_name:String = source_file.get_file().get_basename()
    _sp_frames = SpriteFrames.new()

    var import_option = options

    var file = File.new()
    file.open(source_file, File.READ)
    var toml_str = file.get_as_text()
    file.close()
    var config = ConfigFile.new()
    config.parse(toml_str)

    for sheet_name in config.get_sections():
        var cols = config.get_value(sheet_name,"cols")
        var rows = config.get_value(sheet_name,"rows")
        var counts = config.get_value(sheet_name,"counts")
        var animation_names = config.get_value(sheet_name,"animation_names")
        var sheet_option = {"cols":cols,"rows":rows,"counts":counts,"animation_names":animation_names}
        add_anim(source_file, save_path, sheet_option, sheet_name, _sp_frames)
        print("[SpritesheetToSpriteFrames] cols:%s, rows:%s, counts:%s, animation_names:%s" % [cols, rows, counts, animation_names ])
    print('[SpritesheetToSpriteFrames] %s imported.' % [source_file])
    return ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], _sp_frames)

func add_anim(source_file, save_path, options, img_name, _sp_frames):
    var dir = source_file.get_base_dir()
    var texture = load(dir + '/' + img_name + '.png')
    var cols:int = options.cols as int
    var rows:int = options.rows as int
    var counts:int = options.counts as int
    for col in range(0, cols):
        for row in range(0, rows):
            var name = options.animation_names[(col * rows) + row]
            if name == "":
                continue
            _sp_frames.add_animation(name)
            for i in range(0,counts):
                var atlas = create_atlas(texture, options, row, col, i)
                _sp_frames.add_frame(name, atlas, i)

func create_atlas(texture:StreamTexture, options, row, col, index) -> AtlasTexture :
    var image : Image = texture.get_data()
    var tile_width = image.get_width() / options.cols / options.counts
    var tile_height = image.get_height() / options.rows
    var atlas = AtlasTexture.new()
    var rect = Rect2((tile_width * col * options.counts) + (tile_width * index), tile_height * row, tile_width, tile_height)
    atlas.atlas = texture
    atlas.region = rect
    atlas.flags = 4
    return atlas
