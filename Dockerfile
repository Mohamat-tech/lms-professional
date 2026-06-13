FROM php:8.2-apache

# Enable mod_rewrite
RUN a2enmod rewrite

# Install mysqli extension
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . /var/www/html/

# Configure Apache
RUN echo '<Directory /var/www/html>\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-enabled/lms.conf

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port
EXPOSE 80

CMD ["apache2-foreground"]
