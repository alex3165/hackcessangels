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

public class DetailActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);

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
        CheckBox1.setChecked(true);
        if (true){
            if (CheckBox1.isChecked()){
                //Affiche la carte avec le choix 1


            }
            if (CheckBox2.isChecked()){
                //Affiche la carte avec le choix 1


            }
            if (CheckBox3.isChecked()){
                //Affiche la carte avec le choix 1


            }

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

    public enum HandicapType{
        PHYSICAL, MENTAL, DEAF, PRAGNENT, LUGGAGE

    } ;



}
