public ${name}Procedure() {
	PlayerBlockBreakEvents.AFTER.register((level, player, pos, state, blockEntity) -> {
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("world", level);
		dependencies.put("entity", player);
		dependencies.put("blockstate", state);
		dependencies.put("x", player.getX());
		dependencies.put("y", player.getY());
		dependencies.put("z", player.getZ());
		dependencies.put("px", pos.getX());
		dependencies.put("py", pos.getY());
		dependencies.put("pz", pos.getZ());
		dependencies.put("xpAmount", null);
		execute(dependencies);
	});
}