package com.pure3x.lhuis;

import java.util.ArrayList;
import java.util.List;

public class MainMenuManager {

    private final List<String> menus = new ArrayList<>();

    public MainMenuManager() {

        menus.add("🎮 Iniciar");
        menus.add("💿 Jogos");
        menus.add("⭐ Favoritos");
        menus.add("🌐 Rede");
        menus.add("⚙ Configurações");
        menus.add("📀 Firmware");
        menus.add("ℹ Sobre");
    }

    public List<String> getMenus() {
        return menus;
    }

    public int getCount() {
        return menus.size();
    }

    public String getMenu(int index) {

        if (index < 0 || index >= menus.size())
            return "";

        return menus.get(index);
    }
}
