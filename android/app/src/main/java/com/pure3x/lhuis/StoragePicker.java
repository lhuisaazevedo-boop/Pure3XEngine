package com.pure3x.lhuis;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.provider.DocumentsContract;

public class StoragePicker {

    public static final int REQUEST_FOLDER = 1001;

    public static void open(Activity activity) {

        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);

        intent.addFlags(
                Intent.FLAG_GRANT_READ_URI_PERMISSION
                        | Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                        | Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION
                        | Intent.FLAG_GRANT_PREFIX_URI_PERMISSION
        );

        intent.putExtra(
                DocumentsContract.EXTRA_INITIAL_URI,
                (Uri) null
        );

        activity.startActivityForResult(intent, REQUEST_FOLDER);
    }
}
