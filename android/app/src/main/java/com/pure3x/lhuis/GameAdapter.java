package com.pure3x.lhuis;

import android.graphics.Color;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import java.io.File;
import java.util.List;

public class GameAdapter extends RecyclerView.Adapter<GameAdapter.GameViewHolder> {

    private final List<File> games;
    private final GameScanner scanner;

    public GameAdapter(List<File> games, GameScanner scanner) {
        this.games = games;
        this.scanner = scanner;
    }

    @Override
    public GameViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        LinearLayout layout = new LinearLayout(parent.getContext());
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setPadding(40, 30, 40, 30);
        layout.setBackgroundColor(Color.parseColor("#161B22"));

        TextView title = new TextView(parent.getContext());
        title.setTextColor(Color.WHITE);
        title.setTextSize(18);

        TextView info = new TextView(parent.getContext());
        info.setTextColor(Color.LTGRAY);
        info.setTextSize(14);

        info.setGravity(Gravity.START);

        layout.addView(title);
        layout.addView(info);

        return new GameViewHolder(layout, title, info);
    }

    @Override
    public void onBindViewHolder(GameViewHolder holder, int position) {

        File game = games.get(position);

        holder.title.setText("🎮 " + game.getName());

        StringBuilder text = new StringBuilder();

        text.append("Região: ")
                .append(scanner.getRegion(game));

        if (scanner.isIso(game))
            text.append("\nFormato: ISO");

        else if (scanner.isPkg(game))
            text.append("\nFormato: PKG");

        else
            text.append("\nFormato: Compactado");

        text.append("\nTamanho: ")
                .append(game.length() / 1024 / 1024)
                .append(" MB");

        if (scanner.isDisc2(game))
            text.append("\nDisco 2");

        if (scanner.isDisc3(game))
            text.append("\nDisco 3");

        holder.info.setText(text.toString());
    }

    @Override
    public int getItemCount() {
        return games.size();
    }

    static class GameViewHolder extends RecyclerView.ViewHolder {

        TextView title;
        TextView info;

        public GameViewHolder(
                LinearLayout itemView,
                TextView title,
                TextView info) {

            super(itemView);

            this.title = title;
            this.info = info;
        }
    }
}
