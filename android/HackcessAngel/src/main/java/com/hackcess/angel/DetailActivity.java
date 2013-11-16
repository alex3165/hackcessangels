package com.hackcess.angel;

import android.annotation.TargetApi;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.ActionBar;
import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.os.Build;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.TextView;

public class DetailActivity extends ActionBarActivity {

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        TextView textViewHandicap = (TextView) findViewById(R.id.textViewHandicap);
        HandicapType message=HandicapType.PHYSICAL;
        switch(message)  {
            case PHYSICAL :
                textViewHandicap.setText("Handicape physique");
                break;
            case MENTAL :
                textViewHandicap.setText("handicape mental");
                break;
            case DEAF :
                textViewHandicap.setText("Je suis sourd.");
                break;

            case PRAGNENT :
                textViewHandicap.setText("Je suis enceinte");
                break;

            case LUGGAGE :
                textViewHandicap.setText("J'ai des baggages lourds.");
                break;


        }

        Button Submit=(Button) findViewById(R.id.buttonSubmit);
        CheckBox CheckBox1=(CheckBox) findViewById(R.id.checkBox2);
        CheckBox CheckBox2=(CheckBox) findViewById(R.id.checkBox3);
        CheckBox CheckBox3=(CheckBox) findViewById(R.id.checkBox3);
        CheckBox1.setActivated(true);
        if (Submit.isActivated()){
            if (CheckBox1.isActivated()){
                //Affiche la carte avec le choix 1


            }
            if (CheckBox2.isActivated()){
                //Affiche la carte avec le choix 1


            }
            if (CheckBox3.isActivated()){
                //Affiche la carte avec le choix 1


            }

        }
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

    public enum HandicapType{
        PHYSICAL, MENTAL, DEAF, PRAGNENT, LUGGAGE

    } ;



}
