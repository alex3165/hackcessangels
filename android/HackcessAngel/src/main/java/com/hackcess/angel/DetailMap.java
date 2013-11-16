package com.hackcess.angel;

import android.app.Activity;
import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.TextView;

public class DetailMap extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);

        Button Info=(Button) findViewById(R.id.buttonInfo);
        Button Chair=(Button) findViewById(R.id.buttonChair);
        Button Blind=(Button) findViewById(R.id.buttonBlind);
        Button Move=(Button) findViewById(R.id.buttonMove);
        Button Deaf=(Button) findViewById(R.id.buttonDeaf);


        if (Info.isSelected()){
            //Affiche les infos générales sur la map

        }
        if (Chair.isSelected()){
            //Affiche les accès fauteuils roulants

        }
        if (Blind.isSelected()){
            //Affiche les infos pour les malvoyants

        }
        if (Move.isSelected()){
            //Affiche les accès

        }
        if (Deaf.isSelected()){
            //Affiche les infos audio

        }
    }

    protected void onActivityResult(int requestCode, int resultCode,
                                    Intent data) {
        android.util.Log.d("TEST", "truc");
    }

    protected void onStart() {
        super.onStart();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {

        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }





}
