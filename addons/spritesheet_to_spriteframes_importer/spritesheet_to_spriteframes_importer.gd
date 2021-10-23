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
#            "name": "frame_counts",
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

    var sub_section_dic:Dictionary = {}

    _sp_frames.remove_animation("default")
#   subsection
    for sheet_name in config.get_sections():
        if sheet_name.find("\\") != -1 :
            print(sheet_name)
            var anim_name = sheet_name.split("\\")[1]
            var speed = null
            if config.has_section_key(sheet_name,"speed"):
                speed = config.get_value(sheet_name,"speed")
            var loop = null
            if config.has_section_key(sheet_name,"loop"):
                loop = config.get_value(sheet_name,"loop")
            var frame_enable_counts = null
            if config.has_section_key(sheet_name,"frame_enable_counts"):
                frame_enable_counts = config.get_value(sheet_name,"frame_enable_counts")
            var animations = null
            if config.has_section_key(sheet_name,"animations"):
                animations = config.get_value(sheet_name,"animations")
            var sheet_option = {"speed":speed,"loop":loop,"frame_enable_counts":frame_enable_counts}

            sub_section_dic[anim_name] = sheet_option
            pass

    for sheet_name in config.get_sections():
        if sheet_name.find("\\") != -1 :
#            ignore subsection
            continue
        var cols = config.get_value(sheet_name,"cols")
        var rows = config.get_value(sheet_name,"rows")
        var frame_counts = config.get_value(sheet_name,"frame_counts")
        var speed = null
        if config.has_section_key(sheet_name,"speed"):
            speed = config.get_value(sheet_name,"speed")
        var loop = null
        if config.has_section_key(sheet_name,"loop"):
            loop = config.get_value(sheet_name,"loop")
        var animation_names = config.get_value(sheet_name,"animation_names")
#        var frame_enable_counts = null
#        if config.has_section_key(sheet_name,"frame_enable_counts"):
#            frame_enable_counts = config.get_value(sheet_name,"frame_enable_counts")
        var animations = null
        if config.has_section_key(sheet_name,"animations"):
            animations = config.get_value(sheet_name,"animations")
        var sheet_option = {"cols":cols,"rows":rows,"frame_counts":frame_counts,"animation_names":animation_names,"speed":speed,"loop":loop}
        add_anim(sub_section_dic,source_file, save_path, sheet_option, sheet_name, _sp_frames)
        print("[SpritesheetToSpriteFrames] cols:%s, rows:%s, frame_counts:%s, animation_names:%s" % [cols, rows, frame_counts, animation_names ])
    print('[SpritesheetToSpriteFrames] %s imported.' % [source_file])
    return ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], _sp_frames)

func add_anim(sub_section_dic:Dictionary,source_file, save_path, options, img_name, _sp_frames):
    var dir = source_file.get_base_dir()
    var texture = load(dir + '/' + img_name + '.png')
    var cols:int = options.cols as int
    var rows:int = options.rows as int
    var speed = options.speed
    var loop = options.loop
    var frame_counts:int = options.frame_counts as int

    for col in range(0, cols):
        for row in range(0, rows):
            var name = options.animation_names[(col * rows) + row]
            var frame_enable_counts = null
            print(sub_section_dic)
            if sub_section_dic.has(name) and sub_section_dic[name].has('frame_enable_counts'):
                frame_enable_counts = sub_section_dic[name].frame_enable_counts
            if name == "":
                continue
            if !_sp_frames.has_animation(name):
                _sp_frames.add_animation(name)

                if sub_section_dic.has(name) and sub_section_dic[name].has('speed') and sub_section_dic[name].speed != null:
                    _sp_frames.set_animation_speed(name,sub_section_dic[name].speed)
                elif speed != null:
                    _sp_frames.set_animation_speed(name,speed)

                if sub_section_dic.has(name) and sub_section_dic[name].has('loop') and sub_section_dic[name].loop != null:
                    _sp_frames.set_animation_loop(name,sub_section_dic[name].loop)
                elif loop != null:
                    _sp_frames.set_animation_loop(name,loop)

            for i in range(0,frame_counts):
                if frame_enable_counts == null or frame_enable_counts > _sp_frames.get_frame_count(name):
                    var atlas = create_atlas(texture, options, row, col, i)
                    _sp_frames.add_frame(name, atlas, -1)

func create_atlas(texture:StreamTexture, options, row, col, index) -> AtlasTexture :
    var image : Image = texture.get_data()
    var tile_width = image.get_width() / options.cols / options.frame_counts
    var tile_height = image.get_height() / options.rows
    var atlas = AtlasTexture.new()
    var rect = Rect2((tile_width * col * options.frame_counts) + (tile_width * index), tile_height * row, tile_width, tile_height)
    atlas.atlas = texture
    atlas.region = rect
    atlas.flags = 4
    return atlas
