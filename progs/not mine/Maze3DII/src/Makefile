RES_PATH=res/
MACH3D_PATH=mach3D/
INT_PATH=build/
DEBUG_PATH=debug/
TOOL_PATH=tools/

TASMOPTS=-s -i -b -e $(if $(EVIL),-dEVIL)
PROGNAME=$(if $(EVIL),MAZEEVIL,MAZE3DII)

TOOLS=mapmaker texmaker tablemaker bin28xp
TEXTURES=walltex compass sprite sprite_evil compass_evil walltex_evil
SOURCES=ion.inc stdhead.inc tasm80.tab maze3DII.asm $(MACH3D_PATH)mach3D.asm

MAPMAKER=$(TOOL_PATH)mapmaker/mapmaker
TEXMAKER=$(TOOL_PATH)texmaker/texmaker
TABLEMAKER=$(TOOL_PATH)tablemaker/tablemaker
BIN28XP=$(TOOL_PATH)bin28xp/bin28xp
CONDITION=$(TOOL_PATH)condition/condition

.PHONY : all evil clean distclean

all : maze3DII.8xp $(DEBUG_PATH)mach3D.sym

# final file
DEBUG_FILES=maze3DII.lst maze3DII.sym
INT_FILES=maze3DII.z80 mach3D.z80 ion.inc stdhead.inc tables.inc $(foreach T,$(TEXTURES),$(T).inc)
maze3DII.8xp $(foreach F,$(DEBUG_FILES),$(DEBUG_PATH)$(F)) : $(foreach F,$(INT_FILES),$(INT_PATH)$(F)) $(BIN28XP)
	cd $(INT_PATH) && tasm -80 $(TASMOPTS) -dTI83P maze3DII.z80 maze3DII.bin maze3DII.lst maze3DII.exp maze3DII.sym
	dd ibs=1 skip=40339 if=$(INT_PATH)maze3DII.bin 2>/dev/null | $(BIN28XP) -n $(PROGNAME) -o maze3DII.8xp
	mv -f $(foreach F,$(DEBUG_FILES),$(INT_PATH)$(F)) $(DEBUG_PATH)
	cp -f maze3DII.8xp $(DEBUG_PATH)

# stripped symbol file
$(DEBUG_PATH)mach3D.sym : $(DEBUG_PATH)maze3DII.sym
	egrep '^MACH3D[^X]' >$(DEBUG_PATH)mach3D.sym <$(DEBUG_PATH)maze3DII.sym

# implicit rules

%.z80 : %.asm $(CONDITION)
	$(CONDITION) -i $< -o $@

$(INT_PATH)%.inc : $(RES_PATH)%.ppm $(TEXMAKER)
	$(TEXMAKER) <$< >$@

$(INT_PATH)%.inc : $(RES_PATH)%.t.ppm $(TEXMAKER)
	$(TEXMAKER) -t <$< >$@

# tools
.SECONDARY : $(MAPMAKER) $(TEXMAKER) $(TABLEMAKER) $(BIN28XP)

$(CONDITION) :
	$(MAKE) -C $(dir $(CONDITION))

# copy source files into build directory
$(foreach FN,$(SOURCES),$(INT_PATH)$(notdir $(FN))) : $(SOURCES)
	cp -f $(SOURCES) $(INT_PATH)

# conditional processing
$(INT_PATH)maze3DII.z80 : maze3DII.asm
$(INT_PATH)mach3D.z80 : $(MACH3D_PATH)mach3D.asm

# resources
$(INT_PATH)map.inc : $(RES_PATH)map.txt $(MAPMAKER)
	$(MAPMAKER) <$(RES_PATH)map.txt >$(INT_PATH)map.inc

$(INT_PATH)tables.inc : $(TABLEMAKER)
	$(TABLEMAKER) >$(INT_PATH)tables.inc

evil :
	$(MAKE) clean
	$(MAKE) EVIL=1
	mv -f maze3DII.8xp mazeEvil.8xp

clean :
	rm -f $(INT_PATH)*
	rm -f $(DEBUG_PATH)*
	rm -f maze3DII.8xp mazeEvil.8xp

distclean : clean
	rm -f $(MAPMAKER) $(TEXMAKER) $(TABLEMAKER) $(BIN28XP)
	$(MAKE) clean -C $(dir $(CONDITION))


