<#function mappedBlockToBlockStateCode mappedBlock>
    <#if mappedBlock.toString().contains("(world.") || mappedBlock.toString().contains("/*@BlockState*/")>
        <#return mappedBlock>
    <#elseif mappedBlock.toString().startsWith("CUSTOM:")>
        <#if !mappedBlock.toString().contains(".")>
            <#return JavaModName + "." + (generator.getElementPlainName(mappedBlock))
            + (generator.getRecipeElementType(mappedBlock.toString()) == "BLOCK")?then("_BLOCK", "_ITEM") + ".getDefaultState()">
        <#else>
            <#return JavaModName + "." + (generator.getElementPlainName(mappedBlock))
            + (generator.getRecipeElementType(mappedBlock.toString()) == "BLOCK")?then("_BLOCK", "_ITEM") + "." + generator.getElementExtension(mappedBlock) + ".getDefaultState()">
        </#if>
    <#else>
        <#return mappedBlock + ".getDefaultState()">
    </#if>
</#function>

<#function mappedMCItemToItemStackCode mappedBlock amount>
    <#if mappedBlock?starts_with("/*@ItemStack*/")>
        <#return mappedBlock?replace("/*@ItemStack*/", "")>
    <#elseif mappedBlock?starts_with("CUSTOM:")>
        <#if !mappedBlock?contains(".")>
            <#return "new ItemStack("+ mappedElementToClassName(mappedBlock)
            + (amount == 1)?then(")",", (int)(" + amount + "))")>
        <#else>
            <#return "new ItemStack("+ mappedElementToClassName(mappedBlock) + "."
            + generator.getElementExtension(mappedBlock) + (amount == 1)?then(")",", (int)(" + amount + "))")>
        </#if>
    <#else>
        <#return "new ItemStack(" + mappedBlock + (amount == 1)?then(")",", (int)(" + amount + "))")>
    </#if>
</#function>

<#function mappedElementToClassName mappedElement>
    <#return JavaModName + "." + generator.getElementPlainName(mappedElement) + generator.isRecipeTypeBlockOrBucket(mappedElement)?then("_BLOCK", "_ITEM")>
</#function>

<#function mappedMCItemToItem mappedBlock>
    <#if mappedBlock?starts_with("/*@ItemStack*/")>
        <#return mappedBlock?replace("/*@ItemStack*/", "") + ".getItem()">
    <#elseif mappedBlock?starts_with("CUSTOM:")>
        <#if !mappedBlock.toString().contains(".")>
            <#return JavaModName + "." + (generator.getElementPlainName(mappedBlock)) + "_ITEM">
        <#else>
            <#return JavaModName + "." + (generator.getElementPlainName(mappedBlock)) + "."
                + generator.getElementExtension(mappedBlock)>
        </#if>
    <#else>
        <#return mappedBlock + mappedBlock?contains("Blocks.")?then(".asItem()","")>
    </#if>
</#function>

<#function mappedMCItemToItemStackCodeNoItemStackValue mappedBlock>
    <#if mappedBlock.toString().contains("/*@ItemStack*/")>
        <#return mappedBlock?replace("/*@ItemStack*/", "")>
    <#elseif mappedBlock.toString().startsWith("CUSTOM:")>
        <#if !mappedBlock.toString().contains(".")>
            <#return JavaModName + "." + (generator.getElementPlainName(mappedBlock)) + "_ITEM">
        <#else>
            <#return JavaModName + "." + (generator.getElementPlainName(mappedBlock)) + "."
            + generator.getElementExtension(mappedBlock)>
        </#if>
    <#else>
        <#return mappedBlock.toString().split("#")[0]>
    </#if>
</#function>

<#function mappedMCItemToIngameItemName mappedBlock>
    <#if mappedBlock.getUnmappedValue().startsWith("CUSTOM:")>
        <#assign customelement = generator.getRegistryNameForModElement(mappedBlock.getUnmappedValue().replace("CUSTOM:", "")
        .replace(".helmet", "").replace(".body", "").replace(".legs", "").replace(".boots", ""))!""/>
        <#if customelement?has_content>
            <#return "\"item\": \"" + "${modid}:" + customelement
            + (mappedBlock.getUnmappedValue().contains(".helmet"))?then("_helmet", "")
            + (mappedBlock.getUnmappedValue().contains(".body"))?then("_chestplate", "")
            + (mappedBlock.getUnmappedValue().contains(".legs"))?then("_leggings", "")
            + (mappedBlock.getUnmappedValue().contains(".boots"))?then("_boots", "")
            + "\"">
        <#else>
            <#return "\"item\": \"minecraft:air\"">
        </#if>
    <#elseif mappedBlock.getUnmappedValue().startsWith("TAG:")>
        <#return "\"tag\": \"" + mappedBlock.getUnmappedValue().replace("TAG:", "")?lower_case + "\"">
    <#else>
        <#assign mapped = generator.map(mappedBlock.getUnmappedValue(), "blocksitems", 1) />
        <#if mapped.startsWith("#")>
            <#return "\"tag\": \"" + mapped.replace("#", "") + "\"">
        <#else>
            <#return "\"item\": \"minecraft:" + mapped + "\"">
        </#if>
    </#if>
</#function>

<#function mappedMCItemToIngameNameNoTags mappedBlock>
    <#if mappedBlock.getUnmappedValue().startsWith("CUSTOM:")>
        <#assign customelement = generator.getRegistryNameForModElement(mappedBlock.getUnmappedValue().replace("CUSTOM:", "")
        .replace(".helmet", "").replace(".body", "").replace(".legs", "").replace(".boots", ""))!""/>
        <#if customelement?has_content>
            <#return "${modid}:" + customelement
            + (mappedBlock.getUnmappedValue().contains(".helmet"))?then("_helmet", "")
            + (mappedBlock.getUnmappedValue().contains(".body"))?then("_chestplate", "")
            + (mappedBlock.getUnmappedValue().contains(".legs"))?then("_leggings", "")
            + (mappedBlock.getUnmappedValue().contains(".boots"))?then("_boots", "")>
        <#else>
            <#return "minecraft:air">
        </#if>
    <#elseif mappedBlock.getUnmappedValue().startsWith("TAG:")>
        <#return "minecraft:air">
    <#else>
        <#assign mapped = generator.map(mappedBlock.getUnmappedValue(), "blocksitems", 1) />
        <#if mapped.startsWith("#")>
            <#return "minecraft:air">
        <#else>
            <#return "minecraft:" + mapped>
        </#if>
    </#if>
</#function>

<#function mappedMCItemToBlockStateJSON mappedBlock>
    <#if mappedBlock.getUnmappedValue().startsWith("CUSTOM:")>
        <#assign mcitemresourcepath = mappedMCItemToIngameNameNoTags(mappedBlock)/>
        <#assign ge = w.getWorkspace().getModElementByName(mappedBlock.getUnmappedValue().replace("CUSTOM:", "")
        .replace(".helmet", "").replace(".body", "").replace(".legs", "").replace(".boots", ""))/>
        <#if ge??>
            <#assign ge = ge.getGeneratableElement() />

            <#assign properties = []>
            <#if ge.getModElement().getType().name() == "FLUID">
                <#assign properties += [{"name": "level", "value": 0}] />
            <#elseif ge.getModElement().getType().name() == "PLANT">
                <#if ge.plantType == "growapable">
                    <#assign properties += [{"name": "age", "value": 0}] />
                <#elseif ge.plantType == "double">
                    <#assign properties += [{"name": "half", "value": "lower"}] />
                </#if>
            <#elseif ge.getModElement().getType().name() == "BLOCK">
                <#if ge.blockBase?has_content && ge.blockBase == "Stairs">
                    <#assign properties += [
                    {"name": "facing", "value": "north"},
                    {"name": "half", "value": "bottom"},
                    {"name": "shape", "value": "straight"},
                    {"name": "waterlogged", "value": "false"}
                    ] />
                <#elseif ge.blockBase?has_content && ge.blockBase == "Slab">
                    <#assign properties += [
                    {"name": "type", "value": "bottom"},
                    {"name": "waterlogged", "value": "false"}
                    ] />
                <#elseif ge.blockBase?has_content && ge.blockBase == "Fence">
                    <#assign properties += [
                    {"name": "east", "value": "false"},
                    {"name": "north", "value": "false"},
                    {"name": "south", "value": "false"},
                    {"name": "waterlogged", "value": "false"},
                    {"name": "west", "value": "false"}
                    ] />
                <#elseif ge.blockBase?has_content && ge.blockBase == "Wall">
                    <#assign properties += [
                    {"name": "east", "value": "none"},
                    {"name": "north", "value": "none"},
                    {"name": "south", "value": "none"},
                    {"name": "up", "value": "true"},
                    {"name": "waterlogged", "value": "false"},
                    {"name": "west", "value": "none"}
                    ] />
                <#elseif ge.blockBase?has_content && ge.blockBase == "Leaves">
                    <#assign properties += [
                    {"name": "distance", "value": "7"},
                    {"name": "persistent", "value": "false"}
                    ] />
                <#elseif ge.blockBase?has_content && ge.blockBase == "TrapDoor">
                    <#assign properties += [
                    {"name": "facing", "value": "north"},
                    {"name": "half", "value": "bottom"},
                    {"name": "open", "value": "false"},
                    {"name": "powered", "value": "false"},
                    {"name": "waterlogged", "value": "false"}
                    ] />
                <#elseif ge.blockBase?has_content && ge.blockBase == "Pane">
                    <#assign properties += [
                    {"name": "east", "value": "false"},
                    {"name": "north", "value": "false"},
                    {"name": "south", "value": "false"},
                    {"name": "waterlogged", "value": "false"},
                    {"name": "west", "value": "false"}
                    ] />
                <#elseif ge.blockBase?has_content && ge.blockBase == "Door">
                    <#assign properties += [
                    {"name": "facing", "value": "north"},
                    {"name": "half", "value": "lower"},
                    {"name": "hinge", "value": "left"},
                    {"name": "open", "value": "false"},
                    {"name": "powered", "value": "false"}
                    ] />
                <#elseif ge.blockBase?has_content && ge.blockBase == "FenceGate">
                    <#assign properties += [
                    {"name": "facing", "value": "north"},
                    {"name": "in_wall", "value": "false"},
                    {"name": "open", "value": "false"},
                    {"name": "powered", "value": "false"}
                    ] />
                <#else>
                    <#if ge.isWaterloggable>
                        <#assign properties += [{"name": "waterlogged", "value": "false"}] />
                    </#if>
                </#if>
            </#if>

            <#if properties?has_content>
                <#assign retval='{ "Name": "' + mcitemresourcepath + '", "Properties" : {'/>
                <#list properties as property>
                    <#assign retval = retval + '"' + property.name + '": "' + property.value + '"'/>
                    <#if property?has_next>
                        <#assign  retval = retval + ","/>
                    </#if>
                </#list>
                <#return retval + "} }">
            <#else>
                <#return '{ "Name": "' + mcitemresourcepath + '" }'>
            </#if>
        </#if>
    <#elseif !mappedBlock.getUnmappedValue().startsWith("TAG:")>
        <#assign mapped = generator.map(mappedBlock.getUnmappedValue(), "blocksitems", 1) />
        <#if !mapped.startsWith("#")>
            <#if !mapped.contains(":")>
                <#assign mapped = "minecraft:" + mapped />
            </#if>
            <#assign propertymap = fp.file("utils/defaultstates.json")?eval/>
            <#if propertymap[mapped]?has_content>
                <#assign retval='{ "Name": "' + mapped + '", "Properties" : {'/>
                <#list propertymap[mapped] as property>
                    <#assign retval = retval + '"' + property.name + '": "' + property.value + '"'/>
                    <#if property?has_next>
                        <#assign  retval = retval + ","/>
                    </#if>
                </#list>
                <#return retval + "} }">
            <#else>
                <#return '{ "Name": "' + mapped + '" }'>
            </#if>
        </#if>
    </#if>
    <#return '{ "Name": "minecraft:air" }'>
</#function>

<#function mappedBlockToBlock mappedBlock>
    <#if mappedBlock?starts_with("/*@BlockState*/")>
        <#return mappedBlock?replace("/*@BlockState*/","") + ".getBlock()">
    <#elseif mappedBlock?starts_with("CUSTOM:")>
        <#if !mappedBlock?contains(".")>
            <#return mappedElementToClassName(mappedBlock) + ".block">
        <#else>
            <#return mappedElementToClassName(mappedBlock) + "." + generator.getElementExtension(mappedBlock)>
        </#if>
    <#else>
        <#return mappedBlock>
    </#if>
</#function>